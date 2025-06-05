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
            //implicitHeight: count < 1 ? 0 : itemAtIndex(0).height * count
            //implicitHeight: 400
            //implicitHeight: contentHeight
            height: parent.height
            //model: Services.Notifications.notifications
            model: Services.Notifications.notificationPopupModel

            //verticalLayoutDirection: ListView.BottomToTop

            // Animations 

            // When implicitHeight changes
            /*
            Behavior on implicitHeight {
                SequentialAnimation {
                    // Adds delay to allow for list item animation to play
                    PropertyAnimation {
                        target: notifList
                        properties: ""
                        duration: 0
                    }
                    // Then set the ListView to it's new height
                    PropertyAnimation {
                        properties: "implicitHeight"
                        duration: 0
                    }

                }
            }
            */
            add: Transition {
                SequentialAnimation {
                    /*
                    PropertyAction {
                        alwaysRunToEnd: true
                        target: notifList
                        property: "height"
                        value: notifList.contentHeight
                    }
                    */
                    /*
                    ScriptAction {
                        script: {
                            console.log("anim add")
                            //notif.height = (notif.count + 1) * 100
                        }
                    }
                    */
                    NumberAnimation {
                        properties: "y"
                        from: -200
                        duration: 600
                    }
                }
            }
            /*
            addDisplaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 600
                }
            }
            */
            remove: Transition {
                SequentialAnimation {
                    NumberAnimation {
                        properties: "y"
                        to: 1000
                        duration: 600
                    }
                    /*
                    ScriptAction {
                        alwaysRunToEnd: true
                        script: {
                            console.log("anim remove")
                            notif.height = notif.count * 100
                        }
                    }
                    */
                    /*
                    PropertyAction {
                        alwaysRunToEnd: true
                        target: notifList
                        property: "height"
                        value: notifList.contentHeight
                    }
                    */
                }
            }
            delegate: Modules.Notification {
                Layout.fillWidth: true
                required property var modelData
                notification: modelData.notifObj
            }
        }
    }
}
