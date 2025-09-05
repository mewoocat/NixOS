import Quickshell
import Quickshell.Wayland
import QtQuick

import qs as Root
import qs.Services as Services

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

    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    focusable: true // Enable keyboard focus
    color: "transparent"
    margins {
        top: 16
        right: 16
        left: 16
        bottom: 16
    }
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name

    // Visibility
    visible: false
    onVisibleChanged: {
        if (visible) {
            //console.log(`panel window vis changed to ${window.visible}`)
            Services.Hyprland.addGrabWindow(window)
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
            radius: Root.State.rounding
            children: [
                window.content
            ]
        }
    }
}

