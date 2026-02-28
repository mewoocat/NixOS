pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Modules as Modules

// OSD: This is a transparent window that shows any new notifications for a short time
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

    Rectangle {
        anchors.fill: parent
        color: "transparent"
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

            delegate: Modules.Notification {
                id: notif
                Layout.fillWidth: true
                required property var modelData
                data: modelData
                listView: notifList
                Component.onCompleted: console.log(`notif: ${modelData.desktopEntry}, ${modelData.appName}, ${JSON.stringify(modelData.hints)}`)

                property Timer timer: Timer {
                    interval: 3000
                    running: true
                    onTriggered: {
                        console.log(`notif popup timed out for: ${notif.data.id}`)
                        notif.visible = false
                    }
                    Component.onCompleted: {
                        console.log(`Created timer for: ${notif.data.id}`)
                    }
                }
            }
        }
    }
}
