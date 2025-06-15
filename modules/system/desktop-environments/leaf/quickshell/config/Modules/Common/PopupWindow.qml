import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland

import "../../" as Root

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
        console.log(`setting state for window: ${name}`)
        Root.State[name] = window // Set the window ref in state
    }

    visible: Root.State.controlPanelVisibility
    focusable: true // Enable keyboard focus
    color: "transparent"
    margins {
        top: 16
        right: 16
        left: 16
        bottom: 16
    }
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name

    /////////////////////////////////////////////////////////////////////////
    // Close on click away:
    // Create a timer that sets the grab active state after a delay
    // Used to workaround a race condition with HyprlandFocusGrab where the onVisibleChanged
    // signal for the window occurs before the window is actually created
    // This would cause the grab to not find the window
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 10
        repeat: false
        onTriggered: {
            console.log('panel grab triggered for ' + window.visible)
            //grab.windows.push(window)
            if (!Root.State.popupActive) {
                grab.active = window.visible
            }
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
            ...Root.State.focusGrabIgnore
        ]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log('clearing panel')
            if (!Root.State.popupActive) {
                window.closeWindow()
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////

    // FocusScope is used to ensure the last item with focus set to true
    // receives the actual focus.  This is useful for a text field in
    // a window, as we would want that to have focus but then any non handled
    // key events would automatically propogate up back to the window and
    // handled here.
    // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
    FocusScope {
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            if (event.key == Qt.Key_Escape) {
                window.closeWindow()
            }
        }
        Rectangle {
            id: box
            anchors.fill: parent
            color: palette.window
            radius: 12
            children: [
                window.content
            ]
        }
    }
}

