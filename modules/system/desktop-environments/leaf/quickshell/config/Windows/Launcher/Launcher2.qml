pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Services as Services
import qs.Components.Shared as Shared
import qs as Root

// This is a transparent window that shows any new notifications for a short time
PanelWindow {
    id: root

    implicitWidth: area.width
    implicitHeight: area.height
    //WlrLayershell.namespace: 'notification'
    //WlrLayershell.layer: WlrLayer.Overlay
    exclusiveZone: 0
    anchors {
        bottom: true
        left: true
    }
    color: "transparent"
    visible: false

    Component.onCompleted: {
        Root.State.windows.launcher2 = root
    }


    BackgroundEffect.blurRegion: Region {
        //regions: root.notifRegions.instances
        item: background//.contentItem.children[0]
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
            duration: 500
            easing.type: Easing.Linear
            to: 0
        }
    }

    // Close animation
    SequentialAnimation {
        id: closeAnimation
        PropertyAnimation {
            target: background
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

    Item {
        id: area

        width: background.width + 8 * 2
        height: background.height + 8 * 2

        Rectangle {
            id: background
            width: 300
            height: 150
            x: -300
            color: "#2200ff00"
        }
    }
}


