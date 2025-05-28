pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    readonly property var notifications: server.trackedNotifications

    function enable() {
        console.log("enabling notifications")
    }

    NotificationServer {
        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        persistenceSupported: true

        id: server
        Component.onCompleted: {
            console.log("notification server init")
        }
        onNotification: (notif) => {
            console.log("recieved notification")
            notif.tracked = true
            console.log(`notification: ${notif.id}, ${notif.appName}, tracked? ${notif.tracked}, icon: ${notif.appIcon}, desktop entry: ${notif.desktopEntry}`)

            console.log(`tracked notifications: ${server.trackedNotifications.values}`)
        }
    }
}
