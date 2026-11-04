pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import qs as Root
import qs.Components.Shared as Shared

PanelWindow { // qmllint disable uncreatable-type
    id: root

    property int padding: 8
    property int margin: 8
    property Item content: null

    implicitWidth: background.width
    implicitHeight: background.height
    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    anchors {
        left: true
    }
    visible: false
    color: "transparent"

    Component.onCompleted: {
        Root.State.windows.launcher = launcher
    }

    BackgroundEffect.blurRegion: Region {
        item: focusScope
    }

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
            to: -100
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

    //////////////////////////////////////////////////////////////// 
    // FocusScope is used to ensure the last item with focus set to true
    // receives the actual focus.  This is useful for a text field in
    // a window, as we would want that to have focus but then any non handled
    // key events would automatically propogate up back to the window and
    // handled here.
    // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
    FocusScope {
        x: -100
        id: focusScope
        width: background.width
        height: background.height
        focus: true
        Keys.onPressed: (event) => {
            if (event.key == Qt.Key_Escape) {
                root.closeWindow()
            }
        }
        Rectangle {
            id: background
            color: Root.State.colors.surface
            radius: 0
            width: root.content.width + root.padding * 2
            height: root.content.height + root.padding * 2
            Rectangle {
                id: contentBox
                x: root.padding
                y: root.padding
                color: "transparent"
                width: root.content.width
                height: root.content.height
                children: [ root.content ]
            }
        }
    }

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

}

