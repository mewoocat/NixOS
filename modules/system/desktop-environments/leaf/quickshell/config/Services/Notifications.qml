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
        // Timer to run for popup
        property QtObject timer: Timer {
            interval: 3000
            running: true
            onTriggered: {
                console.log(`notif popup timed out for: ${n.notifObj.id}`)
                root.notificationPopups.splice(0, 1) // pop first element
                console.log("popups length: " + notifService.notificationPopups.length)
            }
            Component.onCompleted: {
                console.log(`Created timer for: ${n.notifObj.id}`)
            }
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
            const notifObject = notificationComp.createObject(null, {notifService: root, notifObj: notif})
            root.notifications.push(notifObject)
            root.notificationPopups.push(notifObject)
        }
    }
    
    // Define a component inline (doesn't create any instances)
    // A Component is just like a .qml file
    /*
    Component {
        id: popupTimer
        // WARNING! this timer implementation 
        Timer {
            required property int index
            interval: 3000
            running: true
            // Looks like this sometimes doesn't trigger
            onTriggered: {
                console.log(`notif popup timed out for index: ${index}`)
                //root.popupNotifications.splice(index, 1) // Remove and condense // No worky?
                root.popupNotifications.splice(0, 1) // pop first element
                console.log("popups length: " + root.popupNotifications.length)
                //root.popupNotifications.pop()
                //timer.destroy()
            }
            Component.onCompleted: {
                console.log(`Created timer for index: ${index}`)
            }
        }
    }
    */

}
