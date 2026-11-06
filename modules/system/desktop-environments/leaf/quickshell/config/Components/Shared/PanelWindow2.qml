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
    property int radius: Root.State.rounding
    property Item content: null
    property int animationTime: 500
    property var easingType: Easing.OutQuad

    implicitWidth: background.width + (root.margin * 2)
    implicitHeight: background.height + (root.margin * 2)
    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    anchors {
        left: true
    }
    visible: false
    color: "transparent"
    WlrLayershell.namespace: 'quickshell-panel' // Set layer name

    Component.onCompleted: {
        Root.State.windows.launcher = launcher
    }

    BackgroundEffect.blurRegion: Region {
        id: blurRegion
        // Note: Seems that when moving a parent of this item, the region doesn't auto update.  However,
        // if this item itself is animated, then the region stays in sync.
        item: background
        radius: root.radius
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
            target: background
            property: "x"
            duration: root.animationTime
            easing.type: root.easingType
            to: root.margin
        }
    }

    // Close animation
    SequentialAnimation {
        id: closeAnimation
        PropertyAnimation {
            target: background
            property: "x"
            duration: root.animationTime
            easing.type: root.easingType
            to: -(background.width + root.margin)
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

    Rectangle {
        id: background

        x: -(width + root.margin) //root.margin
        y: root.margin
        width: focusScope.width + root.padding * 2
        height: focusScope.height + root.padding * 2
        color: Root.State.colors.surface
        radius: root.radius

        //////////////////////////////////////////////////////////////// 
        // FocusScope is used to ensure the last item with focus set to true
        // receives the actual focus.  This is useful for a text field in
        // a window, as we would want that to have focus but then any non handled
        // key events would automatically propogate up back to the window and
        // handled here.
        // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
        FocusScope {
            id: focusScope

            x: root.padding
            y: root.padding
            width: root.content.width
            height: root.content.height
            focus: true
            Keys.onPressed: (event) => {
                if (event.key == Qt.Key_Escape) {
                    root.closeWindow()
                }
            }
            children: [ root.content ]
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

