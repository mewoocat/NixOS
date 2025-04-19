import Applications from 'resource:///com/github/Aylur/ags/service/applications.js'
import App from 'resource:///com/github/Aylur/ags/app.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'
import * as Log from '../Lib/Log.js'
import Gdk from 'gi://Gdk';
import Gtk from 'gi://Gtk'
import icons from '../icons.js'
import GdkPixbuf from 'gi://GdkPixbuf'

const WINDOW_NAME = 'applauncher';
const appDragTarget = [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)]

export const ClientTitle = () => Widget.Label({
    class_name: 'client-title',
    label: Hyprland.active.client.bind('class').as(v => {
        if (v.startsWith("org.") || v.startsWith("com.")){
            let pathList = v.split('.')
            v = pathList[pathList.length - 1]
        }
        if (v.length > 0){
            return v[0].toUpperCase() + v.slice(1)
        }
        return "Desktop"
    }),
});

export const ClientIcon = () => Widget.Icon({
    class_name: 'client-icon',
    }).bind('icon', Hyprland, 'active', p => {
        const icon = Utils.lookUpIcon(p.client.class)

        //icon: Hyprland.active.client.bind("class"),
        if (icon) {
            // icon is the corresponding Gtk.IconInfo
            return p.client.class 
        }
        else {
            // null if it wasn't found in the current Icon Theme
            // Return place holder icon
            return icons.desktop
        }
})

// Note: This assumes the user's special workspace is id -99
export const ToggleScratchpad = () => Widget.Button({
    class_name: "normal-button",
    on_primary_click: () => Hyprland.messageAsync(`dispatch togglespecialworkspace`),
    tooltip_text: "Scratchpad",
    child: Widget.Icon({
        size: 20,
        icon: "focus-windows-symbolic",
    })
}).hook(Hyprland, self => {
    let specialName = JSON.parse(Hyprland.message("j/monitors"))[0].specialWorkspace.id
    self.toggleClassName("active-button", specialName == -99)
})


// Creates a button widget for a given app
const AppItem = (app, size = 42, showText = true) => Widget.EventBox({
    attribute: { app },
    child: Widget.Button({
        class_name: "app-button",
        on_clicked: () => {
            App.closeWindow(WINDOW_NAME);
            app.launch();
        },
        child: Widget.Box({
            children: [
                Widget.Icon({
                    icon: app.icon_name || '',
                    size: size,
                }),
                showText ? Widget.Label({
                    //class_name: 'app-button-label',
                    label: app.name,
                    xalign: 0,
                    vpack: 'center',
                    truncate: 'end',
                }) : undefined,
            ],
        }),
    setup: (self) => {
        const dragIcon = app.icon_name ? app.icon_name : icons.desktop

        // Set this widget as the source for a drag
        self.drag_source_set(
            Gdk.ModifierType.BUTTON1_MASK,
            appDragTarget,
            Gdk.DragAction.COPY
        )

        // Set this widget as a destination for a drag
        self.drag_dest_set(
            Gtk.DestDefaults.ALL,
            appDragTarget,
            Gdk.DragAction.COPY
        )

        self.connect("drag-begin", (widget, context) => {
            Log.Info("drag begin: widget = " + widget)
            widget.drag_source_set_icon_name(dragIcon) // Doesn't work if in setup block
        }) 
        /*
        self.connect("drag-drop", (widget, context, x, y, time) => {
            Log.Info("drap drop")
        }) 
        */
        self.connect("drag-data-get", (widget, context, data, info, time) => {
            const text = "test"
            const setTextResult = data.set_text(text, text.length)
            Log.Info("Set text result = " + setTextResult)
            Log.Info("drag get: data: " + data.get_text())            
        }) 

        self.connect("drag-data-received", (widget, context, x, y, data, info, time) => {
            Log.Info("drag received: data: " + data.get_text())  
            Log.Info("drag received widget = " + widget)
        }) 
    }
    })
})

/////////////////////////////////////////////////////////////////
// Application Launcher
/////////////////////////////////////////////////////////////////

// Generate the list of application widgets on startup
let appWidgets = Applications.query('').map((app) => AppItem(app))

function filterApps(filter = "") {
    appWidgets.forEach(appWidget => {
        appWidget.visible = appWidget.attribute.app.match(filter);
    })
}

// Search entry
const entry = Widget.Entry({
    class_name: "app-entry",
    placeholder_text: "Search...",
    hexpand: true,
    css: `margin-bottom: 8px;`,

    on_accept: (self) => {
        // To launch the first item on Enter 
        // Find first visible
        for (const appWidget of appWidgets) {
            if (appWidget.visible){
                App.toggleWindow(WINDOW_NAME); //Todo: get name from const
                appWidget.attribute.app.launch()
                break
            }
        }


        filterApps("") // Make all apps visible
        self.text = ""
    },

    // Displays or hides results based on filter
    on_change: ({ text }) => {
        filterApps(text)
    },
});

// Highlight first item when entry is selected
// 'notify::"property"' is a event that gobjects send for each property
// https://gjs-docs.gnome.org/gtk30~3.0/gtk.widget
/*
entry.on('notify::has-focus', ({ hasFocus }) => {
    list.toggleClassName("first-item", hasFocus)
})
*/




// Wrap the list in a scrollable container holding the buttons
const appScroller = Widget.Scrollable({
    css: `min-height: 400px;`,
    hscroll: 'never',
        child: Widget.Box({
        vertical: true,
        class_name: "app-list",
        spacing: 4,
        children: appWidgets,
    })
})



// App searcher and list
export const AppLauncher = (WINDOW_NAME) => Widget.Box({
    //vexpand: true,
    vertical: true,
    children: [
        entry,
        appScroller, 
    ],
    setup: self => self.hook(App, (_, windowName, visible) => {
        if (windowName !== WINDOW_NAME)
            return;

        // when the applauncher shows up
        if (visible) {
            entry.text = '';
            entry.grab_focus();
        }
    }),
})


/////////////////////////////////////////////////////////////////
// Vertical App Panel
/////////////////////////////////////////////////////////////////

const Applet = (app) => {
    return Widget.Box({

    })
}

const testApps = Applications.list.splice(0,5).map((app) => {
    return AppItem(app, 28, false)
})

export const VerticalAppPanel = () => {
    return Widget.Box({
        vertical: true,
        children: testApps,
    })
}
