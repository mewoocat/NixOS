import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

import "../../" as Root
import "../../Services" as Services

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
        //console.log(`setting state for window: ${name}`)
        Root.State[name] = window // Set the window ref in state
    }

    // Visibility
    //visible: Root.State.controlPanelVisibility // TODO: need to change this
    visible: false
    property bool prevVisible: false
    onVisibleChanged: {
        if (visible !== prevVisible) {
            //console.log(`panel window vis changed to ${window.visible}`)
            delay.start() // Set grab active status
        }
        prevVisible = visible
    }

    focusable: true // Enable keyboard focus
    color: "transparent"
    margins {
        top: 16
        right: 16
        left: 16
        bottom: 16
    }
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name


    //////////////////////////////////////////////////////////////// 
    // Focus Grab
    //////////////////////////////////////////////////////////////// 
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 100 // If windows are closing right after opening, try adjusting this value
        repeat: false
        onTriggered: {
            if (grab.active !== window.visible) { 
                //console.log('PANEL: grab triggered for ' + window.visible)
                grab.active = window.visible
            }
        }
    }
    // Connects to the active grab window onVisibleChanged signal
    // Starts a small delay which then sets the grab active state to match the window visible state
    /*
    Connections {
        target: window
        function onVisibleChanged() {
            console.log(`window visible changed to: ${window.visible}`)
            if (!window.visible) {
                delay.start() // Set grab active status
            }
        }
    }
    */
    HyprlandFocusGrab {
        id: grab
        Component.onCompleted: {
            Root.State.panelGrab = grab
        }
        active: false
        //onActiveChanged: console.log(`PANEL: grab active set to: ${grab.active}`)
        windows: [window]
        //onWindowsChanged: console.log(`PANEL: grab windows changed`)
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            //console.log('PANEL: clearing grab')
            window.closeWindow() // Assumes this method exists
        }
    }


    //////////////////////////////////////////////////////////////// 
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

