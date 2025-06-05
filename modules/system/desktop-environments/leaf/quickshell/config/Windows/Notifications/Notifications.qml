import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../Services" as Services
import "../../Modules" as Modules
import "../../Modules/Common" as Common

// OSD: This is a transparent window that shows any new notifications for a short time
PanelWindow {
    id: window
    property string name: "notifications"
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name
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

    // TODO: Add new notifications for a limited period of time (osd)
    Rectangle {
        anchors.fill: parent
        //color: "purple"
        color: "transparent"
        ListView {
            id: notifList
            implicitWidth: 400
            height: parent.height
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            model: Services.Notifications.notificationPopupModel
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
                        to: -20
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
                Layout.fillWidth: true
                required property var modelData
                notification: modelData
            }
        }
    }
}
