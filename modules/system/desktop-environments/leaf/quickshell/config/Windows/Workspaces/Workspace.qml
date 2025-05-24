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

    Rectangle {
        id: box
        anchors.centerIn: parent
        // If the workspace doesn't exist, set a fixed smaller size
        implicitWidth: wsObj !== undefined ? parent.width : 64
        implicitHeight: wsObj !== undefined ? parent.height : 64
        radius: 16
        color: root.containsMouse ? palette.highlight : palette.base

        Text {
            color: palette.text
            text: {
                if (root.wsObj === undefined) {
                    return ""
                    //return `ws: ${root.wsId} inactive`
                }
                return `ws: ${root.wsId} focused?: ${root.wsObj.focused}`
            }
        }
   }
}

