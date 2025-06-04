import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../Services" as Services
import "../../Modules" as Modules
import "../../Modules/Common" as Common

// OSD: This is a transparent window that shows any new notifications for a short time
PanelWindow {
    property string name: "notifications"
    WlrLayershell.namespace: 'quickshell-' + name // Set layer name
    visible: true
    anchors {
        top: true
    }
    implicitWidth: 400
    implicitHeight: 300
    color: "transparent"
    //color: "red"
    
    // All other clicks besides on this region pass through the window to ones behind it.
    mask: Region { item: notifList }

    // Works
    //Modules.Notifications {id: notifList}
    
    /*
    ListView {
        model: Services.Notifications.notifications
        anchors.fill: parent
        flickDeceleration: 0.00001
        maximumFlickVelocity: 10000
        clip: true // Ensure that scrolled items don't go outside the widget
        keyNavigationEnabled: true
        delegate: Modules.Notification {
            Layout.fillWidth: true
            required property var modelData
            notification: modelData
        }
    }
    */

    // TODO: Add new notifications for a limited period of time (osd)
    ListView {
        id: notifList
        anchors.fill: parent
        //model: Services.Notifications.notifications
        model: Services.Notifications.notificationPopupModel
        delegate: Modules.Notification {
            Layout.fillWidth: true
            required property var modelData
            notification: modelData.notifObj
        }
    }
}
