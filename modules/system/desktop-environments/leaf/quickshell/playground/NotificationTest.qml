import Quickshell.Services.Notifications

import QtQuick
import Quickshell

import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland

// Singleton {

//     property NotificationServer notifServer:
FloatingWindow {
    id: root
    property var notifs: notifServer.trackedNotifications
    color: "black"

    ListView {
        anchors.fill: parent
        model: root.notifs

        delegate: Rectangle {
            id: notifbackground
            required property Notification modelData
            visible: true
            implicitHeight: 40
            implicitWidth: 80
            color: "red"
            // anchors.fill: parent

            Text {
                id: notifText
                color: "white"
                text: modelData.body
            }
        }
    }

    NotificationServer {
        id: notifServer

        keepOnReload: true
        actionsSupported: false
        actionIconsSupported: false
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        // inlineReplySupported: false
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true;
            console.log(`new notif ${notif}`)
        }
    }

}

