pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root
    readonly property var notifications: server.trackedNotifications

    function enable() {
        console.log("enabling notifications")
    }

    property int popupIndex: 0
    property list<var> popupNotifications: []

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
            
            root.popupNotifications.push(notif)
            const index = root.popupNotifications - 1
            // Create a timer to remove the popup notif
            const timer = Qt.createComponent("Timer.qml")
            //TODO: timer doesn't seem to work
            timer.interval = 3000 // 3 sec
            timer.running = true // start it
            timer.onTriggered = () => {
                console.log(`notif popup timed out`)
                popupNotifications.splice(index, 1) // Remove and condense
                timer.destroy()
            }
        }
    }
}
