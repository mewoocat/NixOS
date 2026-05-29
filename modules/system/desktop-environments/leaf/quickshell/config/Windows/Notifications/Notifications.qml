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
    property int animationSpeed: 300 // ms
    property bool active: Services.Notifications.notificationPopups.values.length > 0
    property bool isAnimationPaused: area.containsMouse
    property string name: "notifications"
    //WlrLayershell.namespace: 'quickshell-' + name
    WlrLayershell.namespace: 'notification'
    WlrLayershell.layer: WlrLayer.Overlay
    visible: true
    exclusiveZone: 0
    anchors {
        top: true
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
        regions: root.notifRegions.instances
    }

    implicitWidth: area.width
    implicitHeight: area.height
    Item {
        id: area

        width: 0
        height: 0

        states: [
            State {
                when: root.active
                name: "shown"
                PropertyChanges {
                    area {
                        width: notifList.width + notifList.spacing * 2
                        height: notifList.height + notifList.spacing * 2
                    }
                }
            }
        ]

        transitions: [
            Transition {
                to: "shown"
                reversible: true
                SequentialAnimation { 
                    PropertyAction { target: area; properties: "width,height" }
                    PauseAnimation { duration: root.animationSpeed }
                }
            }
        ]

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
                    properties: "y"
                    from: -100
                    duration: root.animationSpeed
                }
            }
            addDisplaced: Transition {
                NumberAnimation {
                    properties: "y"
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
            removeDisplaced: Transition {
                NumberAnimation {
                    property: "y"
                    duration: root.animationSpeed
                }
            }

            delegate: Shared.Notification {
                id: notif
                implicitWidth: notifList.width
                required property var modelData
                notifData: modelData
                listView: notifList
                margin: 0
                Component.onCompleted: {
                    console.log(`notif: ${modelData.desktopEntry}, ${modelData.appName}, ${JSON.stringify(modelData.hints)}`)
                }
                onClosed: Services.Notifications.removeNotifFromPopupModel(modelData)
                onContainsMouseChanged: {
                    if (notif.containsMouse) root.isAnimationPaused = true
                    else root.isAnimationPaused = false
                }

                Timer {
                    id: timer
                    interval: 2000
                    running: true && !root.isAnimationPaused
                    onTriggered: Services.Notifications.removeNotifFromPopupModel(notif.modelData)
                }
            }
        }
    }
}
