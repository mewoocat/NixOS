pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../Services" as Services

MouseArea {
    id: root
    required property int wsId

    // Should be of type HyprlandWorkspace or undefined
    property var wsObj: {
        const wsObj = Services.Hyprland.workspaceMap[wsId]
        //console.log(`updated ws: ${wsObj}`)
        //console.log(`ws monitor: ${wsObj.monitor.width}`)
        return wsObj
    }

    // The fixed width of each workspace width
    // The height is calculated using the width and aspect ratio
    property int widgetWidth: 300
    property real aspectRatio: {
        if (wsObj === undefined || wsObj.monitor === null) {
            return 0.5
        }
        return wsObj.monitor.height / wsObj.monitor.width
    }
    // Scale of virtual size to actual size
    property real widgetScale: {
        if (!wsObj || wsObj.monitor === null) {
            return 1
        }
        return widgetWidth / wsObj.monitor.width
    }

    implicitWidth: widgetWidth
    implicitHeight: Math.round(widgetWidth * root.aspectRatio)
    
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (event) => {
        switch(event.button) {
            case Qt.LeftButton:
                Hyprland.dispatch(`workspace ${wsId}`) 
                break
            case Qt.RightButton:
                break
            case Qt.MiddleButton:
                break
            default:
                console.log("button problem")
        }
    }

    // The workspace
    Rectangle {
        id: box
        anchors.centerIn: parent
        // If the workspace doesn't exist, set a fixed smaller size
        implicitWidth: root.wsObj !== undefined ? parent.width : 64
        implicitHeight: root.wsObj !== undefined ? parent.height : 64
        radius: root.wsObj === undefined ? 16 : 0
        color: root.wsObj === undefined && root.containsMouse ? palette.highlight : palette.base

        Loader {
            anchors.fill: parent
            // Only try to render clients if the workspace exists
            active: root.wsObj !== undefined
            Repeater {
                //model: Services.Hyprland.clientMap[root.wsId]
                model: Hyprland.toplevels.values.filter(toplevel => toplevel.workspace.id === root.wsId)
                // Each window in the workspace
                Client {
                    required property var modelData
                    toplevel: modelData
                    clientObj: modelData.lastIpcObject
                    widgetScale: root.widgetScale
                    monitorScale: root.wsObj.monitor.scale
                    monitorX: root.wsObj.monitor.x
                    monitorY: root.wsObj.monitor.y
                    Component.onCompleted: {
                        //console.log(`widget scale: ${widgetScale}`)
                    }
                }
            }
        }
    }

    // Workspace number indicator
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.topMargin: 8
        radius: 16
        implicitHeight: 16
        implicitWidth: 20
        color: palette.accent
        Text {
            anchors.centerIn: parent
            text: root.wsId
            font.pointSize: 10
            color: palette.highlightedText
        }
    }
}

