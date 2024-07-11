import GtkSessionLock from 'gi://GtkSessionLock'
import Gdk from 'gi://Gdk'
import Gtk from 'gi://Gtk'
import App from 'resource:///com/github/Aylur/ags/app.js';
import { BigClock, Clock } from './DateTime.js'

// Holds lock windows for each monitor
let windows = []
let wallpaper = "/home/eXia/Nextcloud/Wallpapers/pexels-dominika-roseclay-2347131.jpg"

// Check for support of the `ext-session-lock-v1` protocol
if (!GtkSessionLock.is_supported()) {
    print("Error: ext-session-lock-v1 is not supported") 
    App.quit()     
}

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

const unlockButton = Widget.Button({
    on_primary_click: () => {
        unlock()
    },
    child: Widget.Label("Unlock"),
})

const passwordEntry = Widget.Entry({
    placeholder_text: 'type here',
    text: '',
    visibility: false,
    onAccept: (self) => {
        Utils.authenticate(self.text)
            .then(() => {
                print('authentication sucessful')
                unlock()
            })
            .catch(err => {
                logError(err, 'unsucessful')
                self.text = ""
            })
    },
})

function createLockWindow(monitor){
    const window = new Gtk.Window({
        // Background image
        child: Widget.Box({
            vertical: true,
            css: `
                background-color: #000000;
                background-image: url("${wallpaper}"); 
                background-position: center;
                background-size: cover;
            `,
            children: [
                // Content
                Widget.Box({
                    hpack: "center",
                    vpack: "center",
                    vexpand: true,
                    vertical: true,
                    children: [
                        BigClock(),
                        // Password entry
                        Widget.Box({
                            children: [
                                passwordEntry,
                                unlockButton,
                            ],
                        }),
                    ]
                })
            ],
        })
    })    
    return window
}

function lockScreen(){
    const display = Gdk.Display.get_default()
    for (let m = 0; m < display.get_n_monitors(); m++) {
        const monitor = display.get_monitor(m)
        const window = createLockWindow(monitor)
        windows.push({window, monitor})
    }
    lock.lock_lock()
    windows.forEach(w => {
        lock.new_surface(w.window, w.monitor)
        w.window.show()
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


