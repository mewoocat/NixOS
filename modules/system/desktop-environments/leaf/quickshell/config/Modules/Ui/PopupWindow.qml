import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland

import "root:/" as Root

PanelWindow {
    id: window
    required property string name // Needs to be camelCase
    required property var content // Thing to place in window
 
    Component.onCompleted: {
        Root.State[name] = window // Set the window ref in state
        console.log(`POPUP ref: ${Root.State.windows[name]}`)
    }

    visible: Root.State.controlPanelVisibility
    focusable: true // Enable keyboard focus
    width: 300
    height: 400
    color: "transparent"
    margins {
        top: 16
        right: 16
        left: 16
        bottom: 16
    }
    WlrLayershell.namespace: name // Set layer name

    /////////////////////////////////////////////////////////////////////////
    // Close on click away:
    // Create a timer that sets the grab active state after a delay
    // Used to workaround a race condition with HyprlandFocusGrab where the onVisibleChanged
    // signal for the window occurs before the window is actually created
    // This would cause the grab to not find the window
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 100
        repeat: false
        onTriggered: grab.active = window.visible
    }
    // Connects to the launcher onVisibleChanged signal
    // Starts a small delay which then sets the grab active state to match the 
    Connections {
        target: window
        function onVisibleChanged() {
            delay.start()
        }
    }
    HyprlandFocusGrab {
        id: grab
        active: false
        windows: [ 
            window, // Self
            Root.State.bar
        ]
        /*
        windows: [ 
            window, // Self
            Root.State.windows["Bar"]
        ]
        */
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log("cleared")
            //Root.State.launcherVisibility = false
            toggleWindow()
        }
    }
    /////////////////////////////////////////////////////////////////////////

    Rectangle {
        anchors.fill: parent
        color: "#aa000000"
        radius: 12

        children: [
            content
        ]
    }
}


