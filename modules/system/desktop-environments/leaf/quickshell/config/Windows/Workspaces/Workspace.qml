import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/" as Root
import "root:/Modules" as Modules
import "root:/Services" as Services
import "root:/Modules/Ui" as Ui

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
        if (wsObj === undefined) {
            //console.log(`wsObj is undefined`)
            return 0.5
        }
        const ratio = wsObj.monitor.height / wsObj.monitor.width
        //console.log("aspectRatio: " + ratio)
        return ratio
    }
    // Scale of virtual size to actual size
    property real widgetScale: {
        if (!wsObj) {
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
        implicitWidth: wsObj !== undefined ? parent.width : 64
        implicitHeight: wsObj !== undefined ? parent.height : 64
        //radius: 16
        color: palette.base

        Loader {
            anchors.fill: parent
            // Only try to render clients if the workspace exists
            active: wsObj !== undefined
            Repeater {
                model: Services.Hyprland.clientMap[root.wsId]
                // Each window in the workspace
                MouseArea {
                    id: window
                    required property var modelData
                    // Need to subtract the monitor positon to account for any monitor offsets
                    x: Math.round((modelData.at[0] - wsObj.monitor.x) * widgetScale * wsObj.monitor.scale)
                    y: Math.round((modelData.at[1] - wsObj.monitor.y) * widgetScale * wsObj.monitor.scale)
                    width: Math.round(modelData.size[0] * widgetScale * wsObj.monitor.scale) 
                    height: Math.round(modelData.size[1] * widgetScale * wsObj.monitor.scale)
                    hoverEnabled: true
                    Rectangle {
                        anchors.fill: parent
                        color: window.containsMouse ? palette.highlight : palette.window
                        radius: 4
                        Text {
                            anchors.centerIn: parent
                            color: palette.text
                            text: window.modelData.class
                        }
                        Component.onCompleted: {
                            //console.log(`modelData for ${wsId}: ${JSON.stringify(modelData)}`)
                            //console.log(`x: ${window.width}, y: ${window.height}, w: ${window.width}, h: ${window.height}`)
                            //console.log("widgetScale " + widgetScale)
                        }
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

