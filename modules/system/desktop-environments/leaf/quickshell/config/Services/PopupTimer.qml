import QtQuick
Timer {
    property int index: 0
    interval: 3000
    running: true
    onTriggered: {
        console.log(`notif popup timed out for ${index}`)
        Notifications.popupNotifications.splice(index, 1) // Remove and condense
        destroy()
    }
}
