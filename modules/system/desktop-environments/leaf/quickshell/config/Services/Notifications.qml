pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications as QsNotifications

Singleton {
    id: root

    // All tracked notifications
    property list<Notification> notifications: []
    property var notificationModel: ScriptModel {
        // Need to create a copy with ...
        // Avoids `Unable to assign QQmlListReference to QVariantList` error
        values: [...notifications]
    }

    // Currently popped up notifications
    property list<Notification> notificationPopups: []
    property var notificationPopupModel: ScriptModel {
        // Need to create a copy with ...
        // Avoids `Unable to assign QQmlListReference to QVariantList` error
        values: [...notificationPopups].reverse()
    }

    function enable() {
        console.log("enabling notifications")
    }

    // Inline component
    component Notification: QtObject {
        id: n
        required property QsNotifications.Notification notifObj
        required property Notifications notifService

        required property string id
        required property string image
        required property string appName
        required property string appIcon
        required property string body
        required property string summary

        // Should ensure that the notifObj is not ever destroyed until 
        // this object is destroyed.  Not needed since we copy over the 
        // properties from the qs notif to this notif component. However,
        // this object may come handy later on.
        property var qsNotifLock: RetainableLock {
          object: n.notifObj
          locked: true
        }

        // Timer to run for popup
        property QtObject timer: Timer {
            id: timer
            interval: 3000
            running: true
            onTriggered: {
                console.log(`notif popup timed out for: ${n.id}`)
                root.notificationPopups.splice(0, 1) // pop first element
                console.log("popups length: " + notifService.notificationPopups.length)
            }
            Component.onCompleted: {
                console.log(`Created timer for: ${n.notifObj.id}`)
            }
        }
        function dismiss() {
            console.log("dismissing notification")
            notifObj.dismiss()
            // Remove from notif lists first
            root.notifications.splice(root.notifications.indexOf(n), 1)
            root.notificationPopups.splice(root.notificationPopups.indexOf(n), 1)
            // Dismiss and destroy self
            //destroy()
        }
    }

    Component {
        id: notificationComp
        Notification {}
    }

    // Listens for notifications
    QsNotifications.NotificationServer {
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
            notif.tracked = true
            const notifObject = notificationComp.createObject(null, {
                notifService: root,
                notifObj: notif,

                id: notif.id,
                image: notif.image,
                appName: notif.appName,
                appIcon: notif.appIcon,
                body: notif.body,
                summary: notif.summary,


            })
            console.log(`notif: ${notif.id}`)
            root.notifications.push(notifObject)
            root.notificationPopups.push(notifObject)

            // Only show 3 popups max at a time
            if (root.notificationPopups.length > 3) {
                console.log("what")
                root.notificationPopups.splice(3, root.notificationPopups.length - 1)
            }
        }
    }
}
