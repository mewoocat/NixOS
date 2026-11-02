pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import qs as Root
import qs.Components.Shared as Shared

PanelWindow { // qmllint disable uncreatable-type
    id: root

    required property string name // Needs to be camelCase
    required property var content // Thing to place in window

    property bool grabEnabled: true
    property int padding: Root.State.windowPadding
    property int radius: Root.State.rounding
    property int inset: 8 // Background inset
    property Item bg: null

    // Visibility
    visible: false

    // Open animation
    SequentialAnimation {
        id: openAnimation
        PropertyAction {
            target: root
            property: "visible"
            value: true
        }
        PropertyAnimation {
            target: focusScope
            property: "x"
            duration: 500
            easing.type: Easing.Linear
            to: 0
        }
    }

    // Close animation
    SequentialAnimation {
        id: closeAnimation
        PropertyAnimation {
            target: focusScope
            property: "x"
            duration: 500
            easing.type: Easing.Linear
            to: -root.width
        }
        PropertyAction {
            target: root
            property: "visible"
            value: false
        }
    }

    function openWindow() {
        openAnimation.start();
    }

    function closeWindow() {
        closeAnimation.start();
    }

    function toggleWindow() {
        visible ? closeWindow() : openWindow();
    }

    // NOTE: Need to set PanelWindow size to largest possible or else resizing will jitter
    implicitWidth: background.width + inset * 2
    implicitHeight: background.height + inset * 2

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    // Create a close on click away area for each screen
    property var clickAway: Variants {
        model: Quickshell.screens
        // qmllint disable uncreatable-type
        PanelWindow {
            visible: root.visible && root.grabEnabled
            required property ShellScreen modelData
            screen: modelData
            focusable: false
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            color: "#00ff0000"
            MouseArea {
                id: area
                hoverEnabled: true
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: () => {
                    console.log(`what`);
                    root.closeRequested();
                }
            }
            // Allow clicks to pass through
            // Doesn't seem to be a way to do this *and* detect mouse clicks
            /*
            mask: Region {
                item: area
                intersection: Intersection.Subtract
            }
            */
        }
    }

    /*
    Component.onCompleted: {
        //console.log(`setting state for window: ${name}`)
        Root.State[name] = window // Set the window ref in state
    }
    */

    //exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    //focusable: true // Enable keyboard focus !! Warning seems to cause Popup.Window popup types to close immediately after opening
    color: "transparent"
    margins {
        top: Root.State.panelMargin
        right: Root.State.panelMargin
        left: Root.State.panelMargin
        bottom: Root.State.panelMargin
    }
    WlrLayershell.namespace: 'something'//'quickshell-panel-' + name // Set layer name
    //WlrLayershell.namespace: 'quickshell' // Set layer name

    /*
    FrameAnimation {
        running: root.visible
        onTriggered: {
            //root.BackgroundEffect.blurRegion.item = null
            //root.BackgroundEffect.blurRegion.item = background
            const point = root.mapFromItem(background, 0, 0)
            blurRegion.x = point.x
            blurRegion.y = point.y
        }
    }
    */
    // Specify the region of the layer to have blur applied to it rather than the whole layer
    BackgroundEffect.blurRegion: Region {
        id: blurRegion
        // It seems that some items just don't want to work here?
        item: focusScope.children[0]
        radius: background.radius
        Component.onCompleted: {
            console.debug(`item .............. ${item}`)
        }
        //width: background.width
        //height: background.height
    }

    /*
    BackgroundEffect.blurRegion: Region {
        regions: [
            Region {
                item: focusScope
                radius: Root.State.rounding
            }
        ]
    }
    */

    Rectangle {
        id: focusScope
        color: "#22440000"
        width: background.width + root.inset * 2
        height: background.height + root.inset * 2 
        property Rectangle background: Rectangle {
            id: background
            x: root.inset
            y: root.inset
            color: "#22004400"
            width: 600
            height: 400
            Rectangle {
                anchors.fill: parent
                anchors.margins: 90
                color: "#22000044"
            }
        }
        children: [ background ]
    }

    /*
    ////////////////////////////////////////////////////////////////
    // FocusScope is used to ensure the last item with focus set to true
    // receives the actual focus.  This is useful for a text field in
    // a window, as we would want that to have focus but then any non handled
    // key events would automatically propogate up back to the window and
    // handled here.
    // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
    FocusScope {
        id: focusScope
        x: -width
        Behavior on x {
            PropertyAnimation {
                duration: 200
                easing.type: Easing.Linear
            }
        }

        width: background.width + root.inset * 2
        height: background.height + root.inset * 2
        focus: true
        Keys.onPressed: event => {
            console.log(`PanelWindow key event`);
            if (event.key == Qt.Key_Escape) {
                root.closeRequested();
            }
        }
        Rectangle {
            id: background
            color: Root.State.colors.surface
            x: root.inset
            y: root.inset
            Behavior on y {
                PropertyAnimation {
                    duration: 50
                    easing.type: Easing.Linear
                }
            }
            Component.onCompleted: {
                root.bg = background
            }
            radius: root.radius
            implicitWidth: root.content.width + root.padding * 2
            implicitHeight: root.content.height + root.padding * 2
            Rectangle {
                id: content
                x: root.padding
                y: root.padding
                color: "transparent"
                implicitWidth: root.content.width
                implicitHeight: root.content.height
                children: [root.content]
            }
        }
    }
    */

}
