pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Services as Services
import qs as Root

Rectangle {
    id: root
    implicitHeight: indicator.height + workspace.height
    implicitWidth: workspace.width
    color: "transparent"
    required property int wsId
    required property int widgetWidth
    // Should be of type HyprlandWorkspace or undefined
    property var wsObj: Services.Hyprland.workspaceMap[wsId]
    property bool isWsActive: Services.Hyprland.activeWsId === wsId
    property string wsName: Root.State.config.workspaces.wsMap[`ws${root.wsId}`].name
    //z: wsId === 1 ? 1 : 0

    // Workspace number indicator
    Rectangle {
        id: indicator
        radius: 16
        color: isWsActive ? palette.accent : "transparent"
        implicitWidth: displayText.width
        implicitHeight: 18

        Text {
            id: displayText
            anchors.centerIn: parent
            leftPadding: 8
            rightPadding: 8
            text: root.wsName === "" ? root.wsId : root.wsId + " | " + root.wsName
            font.pointSize: 8
            color: root.isWsActive ? palette.highlightedText : palette.text
        }
    }

    MouseArea {
        id: workspace
        anchors.topMargin: 8
        anchors.top: indicator.bottom
        anchors.left: indicator.left

        // The fixed width of each workspace width
        // The height is calculated using the width and aspect ratio
        property int widgetWidth: root.widgetWidth
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
        implicitHeight: Math.round(widgetWidth * aspectRatio)
        
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
            radius: root.wsObj === undefined ? 16 : 8
            color: root.wsObj === undefined && workspace.containsMouse ? palette.highlight : palette.alternateBase
            //color: "transparent"

            Loader {
                anchors.fill: parent
                // Only try to render clients if the workspace exists
                active: root.wsObj !== undefined
                Repeater {
                    //model: Services.Hyprland.clientMap[root.wsId]
                    model: Hyprland.toplevels.values.filter(toplevel => {
                        toplevel.workspace !== null && // workspace can be null
                        toplevel.monitor !== null && // monitor can be null
                        toplevel.workspace.id === root.wsId
                    })
                    // Each window in the workspace
                    Client {
                        required property HyprlandToplevel modelData
                        toplevel: modelData
                        clientObj: modelData.lastIpcObject
                        widgetScale: workspace.widgetScale
                        monitorScale: root.wsObj.monitor.scale
                        monitorX: root.wsObj.monitor.x
                        monitorY: root.wsObj.monitor.y
                        // Moves the workspace to the top when one of its clients is being dragged
                        drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
                    }
                }
            }
        }
    }

    // Accepts client drops
    DropArea {
        anchors.fill: parent
        //onContainsDragChanged: console.log(`contains drag = ${containsDrag}`)
        onEntered: console.log(`entered`)
        onDropped: (drop) => {
            // Apparently you need to cast the source type before you can use it 
            const clientPid = (drag.source as MouseArea).clientObj.pid
            console.log(`dropped ${(drag.source as MouseArea).clientObj.Pid}`)
            Hyprland.dispatch(`movetoworkspacesilent ${root.wsId}, pid:${clientPid}`)
        }
    }
}
