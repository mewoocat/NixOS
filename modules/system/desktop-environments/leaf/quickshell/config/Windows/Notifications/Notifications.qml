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
    id: window
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
        model: notifList.contentItem.children
        Region {
            required property Item modelData
            item: modelData
            radius: Root.State.rounding
        }
    }
    BackgroundEffect.blurRegion: Region {
        regions: notifRegions.instances
    }

    property bool notifsActive: Services.Notifications.notificationPopups.values.length > 0
    implicitWidth: notifsActive ? notifList.width + notifList.spacing : 0
    implicitHeight: notifsActive ? notifList.height + notifList.spacing : 0
    ListView {
        id: notifList
        implicitWidth: 320
        anchors.topMargin: spacing
        height: 600
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        model: Services.Notifications.notificationPopups
        property int animationSpeed: 1000 // ms
        spacing: 8

        // Animations 
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: -100
                duration: notifList.animationSpeed
            }
        }
        addDisplaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: notifList.animationSpeed
            }
        }
        remove: Transition {
            SequentialAnimation {
                NumberAnimation {
                    properties: "x"
                    to: -8
                    duration: 100
                }
                NumberAnimation {
                    properties: "y"
                    to: -100
                    duration: notifList.animationSpeed
                }
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
            onClosed: Services.Notifications.notificationPopups.values.pop()
            onContainsMouseChanged: {
                if (notif.containsMouse) {timer.stop()}
                else {timer.start()}
            }

            Timer {
                id: timer
                interval: 2000
                running: true
                //onTriggered: Services.Notifications.notificationPopups.values.pop() // Remove the notif from popup model
            }
        }
    }
}
