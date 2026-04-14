pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls

ColumnLayout {
    id: root
    required property int wsId
    required property int widgetWidth
    property HyprlandWorkspace wsObj: Services.Hyprland.workspaces.filter(w => w.id == wsId) ?? null
    property bool isWsActive: Services.Hyprland.activeWsId === wsId
    property string wsName: wsId//Root.State.config.workspaces.wsMap[`ws${root.wsId}`].name
    implicitHeight: workspace.height + indicator.height
    implicitWidth: workspace.width

    // Workspace number indicator
    WrapperRectangle {
        id: indicator
        z: 1
        radius: height / 2
        color: Root.State.colors.surface_container_highest
        Layout.fillWidth: true
        Layout.margins: 4

        RowLayout {
            Text {
                id: displayText
                leftPadding: 14
                rightPadding: 8
                topPadding: 4
                bottomPadding: 4
                text: root.wsName === "" ? root.wsId : root.wsName
                font.pointSize: 10
                color: Root.State.colors.on_surface
            }
            TextField {

            }
            Rectangle {
                Layout.fillWidth: true
            }
            Ctrls.Button {
                text: "Delete"
                implicitHeight: 32
                inset: 4
            }
        }
    }

    MouseArea {
        id: workspace
        // The fixed width of each workspace width
        // The height is calculated using the width and aspect ratio
        property int widgetWidth: root.widgetWidth
        property real aspectRatio: {
            // This should only occur on initial startup, might be worth using a loader instead
            if (!wsObj || wsObj.monitor === null) {
                return 0.5
            }
            return wsObj.monitor.height / wsObj.monitor.width
        }
        // Scale of virtual size to actual size
        property real widgetScale: {
            // This should only occur on initial startup, might be worth using a loader instead
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
            color: "transparent"//Root.State.colors.surface_container

            Loader {
                anchors.fill: parent
                // Only try to render clients if the workspace exists
                active: root.wsObj !== null
                property Component clients: Repeater {
                    model: Hyprland.toplevels.values.filter(toplevel => {
                        return toplevel.workspace !== null &&
                        toplevel.monitor !== null &&
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

        // Accepts client drops
        DropArea {
            id: dropArea
            anchors.fill: parent
            property alias wsId: root.wsId
            keys: [ "workspace-client" ] // Drag source must have this key or it's ignored
            onDropped: (drop) => {
                // Apparently you need to cast the source type before you can use it 
                const clientObj = (drag.source as MouseArea).clientObj
                console.log(`dropped client with pid ${clientObj.pid} from ws ${clientObj.workspace.id}`)
                Hyprland.dispatch(`movetoworkspacesilent ${root.wsId}, pid:${clientObj.pid}`)
                Hyprland.refreshToplevels() // Need to refresh to rerender changes to clients
            }

            // Object being dragged over indicator
            Rectangle {
                anchors.fill: parent
                radius: 8
                color: parent.containsDrag ? "#55000000" : "transparent"
            }
        }
    }
}
