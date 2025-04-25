import Applications from 'resource:///com/github/Aylur/ags/service/applications.js'
import App from 'resource:///com/github/Aylur/ags/app.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'
import * as Log from '../Lib/Log.js'
import Gdk from 'gi://Gdk';
import Gtk from 'gi://Gtk'
import icons from '../icons.js'
import * as Helper from '../Lib/Helper.ts'

const WINDOW_NAME = 'applauncher';
const appDragTarget = [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)]
// When doing a drag and drop operation the source widget is stored here in order to 
// reference it from within the destination handler
let dragSource = undefined

export const ClientTitle = () => Widget.Label({
    class_name: 'client-title',
    label: Hyprland.active.client.bind('class').as(v => Helper.formatClientName(v)),
});

export const ClientIcon = () => Widget.Icon({
    class_name: 'client-icon',
}).bind('icon', Hyprland, 'active', v => Helper.lookupClientIcon(v.client.class))

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
const AppItem = (app, size = 42, showText = true, editable = false) => Widget.Button({
    attribute: { app, editable: editable },
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

        self.connect("drag-begin", (widget, context) => {
            Log.Info("drag-begin")
            const iconSize = self.child.children[0].size
            widget.drag_source_set_icon_name(dragIcon) // Doesn't work if in setup block
            dragSource = widget 
            // Set a placeholder icon if modifying source
            if (editable) { 
                widget.child.children[0].set_from_icon_name("box", iconSize)
            }
        }) 
        self.connect("drag-data-get", (widget, context, data, info, time) => {
            const text = JSON.stringify(app)
            const setTextResult = data.set_text(text, text.length)
        }) 

        // If edtiable then set this widget as a drag destination
        if (editable) {
            // Set this widget as a destination for a drag
            self.drag_dest_set(
                Gtk.DestDefaults.ALL,
                appDragTarget,
                Gdk.DragAction.COPY
            )
            self.connect("drag-data-received", (widget, context, x, y, data, info, time) => {
                Log.Info("drag-data-received")
                /*
                const ourApp = app
                const theirApp = JSON.parse(data.get_text())
                const iconSize = self.child.children[0].size
                const ourIcon = self.child.children[0].icon
                const theirIcon = app["icon-name"]
                */

                //self.child.children[0].set_from_icon_name(theirIcon, iconSize)
                //dragSource.child.children[0].set_from_icon_name(ourIcon, iconSize)
                const dstParent = widget.parent
                const sourceParent = dragSource.parent
                const dstIndex = dstParent.children.findIndex(item => item === widget)
                const sourceIndex = sourceParent.children.findIndex(item => item === dragSource)
                // i don't think it works like this lol
                //dstParent[dstIndex] = dragSource
                //sourceParent[sourceIndex] = widget
                Log.Info(`dstIndex = ${dstIndex} | sourceIndex = ${sourceIndex}`)


                const isSourceEditable = dragSource.attribute.editable
                // Swap source and destination
                if (isSourceEditable) {
                    Log.Info("Swapping")
                    // Move destination to source
                    dstParent.remove(widget)
                    sourceParent.add(widget)
                    sourceParent.reorder_child(widget, sourceIndex)

                    // Move source to destination
                    sourceParent.remove(dragSource)
                    dstParent.add(dragSource)
                    dstParent.reorder_child(dragSource, dstIndex)
                }

                //
                else {
                    Log.Info("Copying")
                    // Move source to destination
                    dstParent.remove(widget)
                    //widget.destroy()
                    const dragSourceNew = AppItem(dragSource.attribute.app, 28, false, true)
                    dstParent.add(dragSourceNew) 
                    dstParent.reorder_child(dragSourceNew, dstIndex)
                    dstParent.show_all()
                }
                
            }) 

            self.connect("drag-drop", (widget, context, x, y, time) => {
                Log.Info("drag-drop")
                Gtk.drag_finish(context, true, false, time) // Not sure what this is actually doing


                const iconSize = dragSource.child.children[0].size
                Log.Info(`size = ${iconSize}`)
                dragSource.child.children[0].set_from_icon_name(dragSource.attribute.app["icon-name"], iconSize)
            }) 

        }
    }
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
    return AppItem(app, 28, false, true)
})

export const VerticalAppPanel = () => {
    return Widget.Box({
        vertical: true,
        children: testApps,
    })
}
