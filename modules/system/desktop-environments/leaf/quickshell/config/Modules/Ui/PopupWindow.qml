import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Hyprland

import "root:/" as Root

// TODO: I think that the required keyword doesn't trigger an error on missing 
// prop with the PanelWindow type (need to test)
PanelWindow {
    id: window
    required property string name // Needs to be camelCase
    required property var content // Thing to place in window
    required property var closeWindow
    //required property var action
    required property var toggleWindow
 
    Component.onCompleted: {
        Root.State[name] = window // Set the window ref in state
    }

    visible: Root.State.controlPanelVisibility
    focusable: true // Enable keyboard focus
    //width: 300
    //height: 400
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
        onTriggered: {
            //grab.windows.push(window)
            grab.active = window.visible
            //content.forceActiveFocus() // Seems to make it not focus the textfield when hovering
        }
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
            //Root.State.bar // Disabling for now as it causes popup window to loose focus until hovered
        ]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log("cleared")
            //Root.State.launcherVisibility = false
            //toggleWindow()
            closeWindow()
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

