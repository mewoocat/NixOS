import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

import qs as Root
import qs.Services as Services

// TODO: I think that the required keyword doesn't trigger an error on missing 
// prop with the PanelWindow type (need to test)
PanelWindow {
    id: window
    required property string name // Needs to be camelCase
    required property var content // Thing to place in window
    property bool grabEnabled: true
    property int padding: Root.State.windowPadding
    property int radius: Root.State.rounding

    signal closeWindow()
    signal toggleWindow()
 
    Component.onCompleted: {
        //console.log(`setting state for window: ${name}`)
        Root.State[name] = window // Set the window ref in state
    }

    exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    //focusable: true // Enable keyboard focus !! Warning seems to cause Popup.Window popup types to close immediately after opening
    color: "transparent"
    /*
    margins {
        top: 8
        right: 8
        left: 8
        bottom: 8
    }
    */
    WlrLayershell.namespace: 'quickshell-panel-' + name // Set layer name
    //WlrLayershell.namespace: 'quickshell' // Set layer name
    // Specify the region of the layer to have blur applied to it
    BackgroundEffect.blurRegion: Region {
        item: background
        radius: background.radius
    }

    // Visibility
    visible: false

    // TODO: make each panel window have their own focus grab
    /*
    onVisibleChanged: {
        if (window.grabEnabled) {
            if (visible) {
                Root.State.clickAwayVisible = true
                Root.State.focusStack.push(window)
            }
            else {
                Root.State.focusStack.pop()
            }
        }
    }
    */

    implicitWidth: background.width
    implicitHeight: background.height // NOTE: Need to set PanelWindow size to largest possible or else resizing with jitter

    //////////////////////////////////////////////////////////////// 
    // FocusScope is used to ensure the last item with focus set to true
    // receives the actual focus.  This is useful for a text field in
    // a window, as we would want that to have focus but then any non handled
    // key events would automatically propogate up back to the window and
    // handled here.
    // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
    FocusScope {
        id: focusScope
        width: background.width
        height: background.height
        focus: true
        Keys.onPressed: (event) => {
            if (event.key == Qt.Key_Escape) {
                window.closeWindow()
            }
        }
        Rectangle {
            id: background
            color: Root.State.colors.surface
            radius: window.radius
            implicitWidth: window.content.width + window.padding * 2
            implicitHeight: window.content.height + window.padding * 2
            Rectangle {
                x: window.padding
                y: window.padding
                color: "transparent"
                implicitWidth: window.content.width
                implicitHeight: window.content.height
                children: [
                    window.content
                ]
            }
        }
    }
}

