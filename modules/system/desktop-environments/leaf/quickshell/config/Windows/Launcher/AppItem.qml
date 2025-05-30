// WARNING: Unused atm

import QtQuick.Controls
import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import "root:/" as Root

Item {
required property var app

MouseArea {
    id: appItem

    // Filter using search text
    visible: {
        if (
            app.name.toLowerCase().includes(app.name.toLowerCase())
        ) {
            return true
        }
        return false
    }
    Layout.fillWidth: true
    height: 36
    hoverEnabled: true
    onClicked: {
        console.log('app click')
        Root.State.launcher.toggleWindow()
        app.execute()
    }
    Rectangle {
        anchors.fill: parent
        anchors {
            leftMargin: 16
            rightMargin: 16
            topMargin: 4
            bottomMargin: 4
        }
        color: mouseArea.containsMouse ? "#00ff00" : "transparent"
        radius: 10
        RowLayout {
            anchors.fill: parent
            IconImage {
                implicitSize: 32
                source: Quickshell.iconPath(app.icon)
            }
            Text {
                text: "wtf"
            }
            Text{
                width: 80
                color: "red"
                clip: true
                text: app.name
            }
        }
    }
}
}
