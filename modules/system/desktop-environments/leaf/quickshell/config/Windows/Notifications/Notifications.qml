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
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name
    WlrLayershell.layer: WlrLayer.Overlay
    visible: true
    anchors {
        top: true
        bottom: true
        left: true
        right: true
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

    ListView {
        id: notifList
        implicitWidth: 400
        height: parent.height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        model: Services.Notifications.notificationPopups
        property int animationSpeed: 300 // ms

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
                onTriggered: Services.Notifications.notificationPopups.values.pop() // Remove the notif from popup model
            }
        }
    }
}
