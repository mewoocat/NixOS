import GtkSessionLock from 'gi://GtkSessionLock'
import Gdk from 'gi://Gdk'
import Gtk from 'gi://Gtk'
import App from 'resource:///com/github/Aylur/ags/app.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { Weather } from './Modules/Weather.js';
import { Clock } from './Modules/DateTime.js'
import { UserIcon, UserName } from './Modules/User.js'
import icons from './icons.js';


import * as Options from './Options/options.js'
Options.GetOptions()

const WeatherWidget = Weather()

//////////////////////////////////////////////////////////////////////
// Check for support of the `ext-session-lock-v1` protocol
//////////////////////////////////////////////////////////////////////
if (!GtkSessionLock.is_supported()) {
    print("Error: ext-session-lock-v1 is not supported") 
    App.quit()     
}

//////////////////////////////////////////////////////////////////////
// App config
//////////////////////////////////////////////////////////////////////

const scss = `${App.configDir}/Style/style.scss`
const css = `${App.configDir}/Style/style.css`
Utils.exec(`sassc ${scss} ${css}`)
Utils.monitorFile(
    `${App.configDir}/Style/_colors.scss`,
    function() {
        Utils.exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/Style/style.css`);
    },
);

App.config({
    style: css, 
})


//////////////////////////////////////////////////////////////////////
// Globals
//////////////////////////////////////////////////////////////////////

// Holds lock windows for each monitor
let windows = []
let wallpaper = `${App.configDir}/../../.cache/wallpaper` 

//////////////////////////////////////////////////////////////////////
// Functions
//////////////////////////////////////////////////////////////////////

function onLocked(){
    print("Locked")
}

function onFinished(){
    print("Finished")
    //GtkSessionLock.lock_destroy(lock)
    App.quit()     
}

function unlock() {
    lock.unlock_and_destroy()
    // Destory each window
    windows.forEach(w => w.window.destroy())
    // Before exiting your application, 
    // you MUST wait for a Wayland display sync.
    Gdk.Display.get_default().sync()
    // Quit screen locker
    App.quit()
}

function authenticate(entry){ 
    Utils.authenticate(entry.text)
        .then(() => {
            print('authentication sucessful')
            unlock()
        })
        .catch(err => {
            logError(err, 'unsucessful')
            entry.text = ""
        })
}


const passwordEntry = Widget.Entry({
    class_name: "app-entry",
    placeholder_text: 'Password',
    vpack: "center",
    text: '',
    visibility: false,
    onAccept: (self) => {
        authenticate(self)
    },
})

const unlockButton = Widget.Button({
    class_name: "normal-button bg-button",
    on_primary_click: () => {
        authenticate(passwordEntry)
    },
    child: Widget.Label("Unlock"),
})

function LockscreenWidget(widget, w, h) {
    const box = Widget.Box({
        class_name: "lockscreen-widget",
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        children: [ widget ],
    })
    return box;
}

function LockscreenContents(monitorID){
    if (monitorID != 0){
        return null
    }
    return Widget.Overlay({
        hexpand: true,
        child: Widget.Box({
            hpack: "center",
            vpack: "center",
            vexpand: true,
            hexpand: true,
            vertical: true,
            spacing: 12,
            children: [
                UserIcon(8),
                UserName(1.6),
                // Password entry
                Widget.Box({
                    class_name: "toggle-window bg-0",
                    vpack: "center",
                    spacing: 8,
                    children: [
                        passwordEntry,
                        unlockButton,
                    ],
                }),
            ]
        }),

        overlays: [
            // Bar 
            Widget.CenterBox({
                vpack: "start",
                class_name: "bar-window-lockscreen",
                start_widget: Widget.Icon({
                    hexpand: true,
                    hpack: "start",
                    css: `margin-left: 1.6em;`,
                    icon: icons.lock,
                }),
                center_widget: Clock(),
            }),
                
            // Bottom left
            Widget.Box({
                vexpand: true,
                hexpand: true,
                hpack: "start",
                vpack: "end",
                css: `padding: 1em;`,
                children: [
                    LockscreenWidget(WeatherWidget, 12, 12),
                ],
            })
        ]
    })
}

function createLockWindow(monitor, id){

    const window = new Gtk.Window({
        // Background image
        child: Widget.Box({
            css: `
                background-color: #000000;
                background-image: url("${wallpaper}"); 
                background-position: center;
                background-size: cover;
            `,
            children: [
                LockscreenContents(id),
            ],
        })
    })    
    windows.push({window, monitor})
    return window
}

function lockScreen(){
    const display = Gdk.Display.get_default()
    // For all current monitors
    for (let m = 0; m < display.get_n_monitors(); m++) {
        const monitor = display.get_monitor(m)
        createLockWindow(monitor, m)
    }
    lock.lock_lock()
    windows.forEach(w => {
        lock.new_surface(w.window, w.monitor)
        w.window.show()
    })

    // For added / removed monitors
    display.connect("monitor-added", (display, monitor) => {
        const window = createLockWindow(monitor)
        lock.new_surface(window, monitor)
        window.show()
    })
    display.connect("monitor-removed", (display, monitor) => {
    })
}


//////////////////////////////////////////////////////////////////////
// Perform lock
//////////////////////////////////////////////////////////////////////

print("Setting up lock")
const lock = GtkSessionLock.prepare_lock()
lock.connect("locked", onLocked)
lock.connect("finished", onFinished)
lockScreen()


