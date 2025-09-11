pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Services as Services
import qs as Root

Item {
    id: root
    implicitHeight: indicator.height + workspace.height
    implicitWidth: workspace.width
    required property int wsId
    required property int widgetWidth
    // Should be of type HyprlandWorkspace or undefined
    property var wsObj: Services.Hyprland.workspaceMap[wsId] ?? null
    property bool isWsActive: Services.Hyprland.activeWsId === wsId
    property string wsName: Root.State.config.workspaces.wsMap[`ws${root.wsId}`].name

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
            if (!wsObj || wsObj.monitor === null) {
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
            implicitWidth: root.wsObj ? parent.width : 64
            implicitHeight: root.wsObj ? parent.height : 64
            radius: 8
            color: !root.wsObj && workspace.containsMouse ? palette.highlight : palette.alternateBase

            Loader {
                anchors.fill: parent
                // Only try to render clients if the workspace exists
                active: root.wsObj !== null
                property Component clients: Repeater {
                    //model: Services.Hyprland.clientMap[root.wsId]
                    model: Hyprland.toplevels.values.filter(toplevel => {
                        return toplevel.workspace !== null && // workspace can be null
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
                sourceComponent: clients
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
            Hyprland.refreshToplevels() // Need to refresh to rerender changes to clients
        }

        // Object being dragged over indicator
        Rectangle {
            anchors.fill: parent
            color: parent.containsDrag ? palette.base : "transparent"
        }
    }
}
