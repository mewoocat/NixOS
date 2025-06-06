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
                model: Services.Hyprland.clientMap[root.wsId]
                // Each window in the workspace
                Client {
                    required property var modelData
                    clientObj: modelData
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
        /*
        Text {
            color: palette.text
            text: {
                if (root.wsObj === undefined) {
                    return ""
                    //return `ws: ${root.wsId} inactive`
                }
                //return `ws: ${root.wsId} focused?: ${root.wsObj.focused}`
                let thing = ""
                for (const client of Services.Hyprland.clientMap[root.wsId]) {
                    thing += client.title + "\n"
                }
                return thing
            }
        }
        */
   }
}

