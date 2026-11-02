pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Components.Shared as Shared
import qs as Root

// This is a transparent window that shows any new notifications for a short time
PanelWindow {
    id: root
    property int animationSpeed: 2000 // ms
    property bool active: Services.Notifications.notificationPopups.values.length > 0
    property bool isAnimationPaused: area.containsMouse
    property string name: "notifications"
    //WlrLayershell.namespace: 'quickshell-' + name
    WlrLayershell.namespace: 'notification'
    WlrLayershell.layer: WlrLayer.Overlay
    visible: true
    exclusiveZone: 0
    anchors {
        bottom: true
    }
    color: "transparent"
    
    // All other clicks besides on this region pass through the window to ones behind it.
    mask: Region { item: notifList.contentItem }

    // Specify the regions of this layer to have blur applied to it.  In this case, each notification item
    property Variants notifRegions: Variants {
        model: notifList.contentItem.children.filter(c => c instanceof Item)
        Region {
            required property Item modelData
            item: modelData
            radius: Root.State.rounding
        }
    }
    BackgroundEffect.blurRegion: Region {
        //regions: root.notifRegions.instances
        item: notifList//.contentItem.children[0]
    }

    implicitWidth: area.width
    implicitHeight: area.height
    Item {
        id: area

        width: notifList.width + 8 * 2
        height: notifList.height + 8 * 2

        Rectangle {
            id: notifList
            width: 300
            height: 150
            Component.onCompleted: {
                y = -100
            }
            color: "#2200ff00"
            Behavior on y {
                PropertyAnimation {
                    duration: 1000
                    easing.type: Easing.Linear
                }
            }
            
        }

        /*
        ListView {
            id: notifList
            implicitWidth: 320
            anchors.topMargin: spacing
            height: 600 
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            model: Services.Notifications.notificationPopups
            spacing: 8

            // Animations 
            add: Transition {
                NumberAnimation {
                    properties: "x"
                    from: -100
                    duration: root.animationSpeed
                }
            }
            remove: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        properties: "x"
                        to: -8
                        duration: 100
                    }
                    NumberAnimation {
                        properties: "y"
                        to: -100
                        duration: root.animationSpeed
                    }
                }
            }

            delegate: Rectangle {
                width: 300
                height: 150
                color: "#2200ff00"
            }
        }
        */
    }
}
