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
    required property int widgetWidth
    required property HyprlandWorkspace ws
    property bool isWsActive: Services.Hyprland.activeWorkspace.id == ws.id
    implicitHeight: workspace.height + indicator.height
    implicitWidth: workspace.width

    // Workspace status bar
    WrapperRectangle {
        id: indicator
        z: 1
        radius: height / 2
        color: Root.State.colors.surface_container_highest
        Layout.fillWidth: true
        Layout.margins: 4

        RowLayout {
            spacing: 0
            Ctrls.Button {
                hoverEnabled: false
                text: root.ws.id
            }
            TextField {
                id: nameField
                onVisibleChanged: {
                    focus = false
                    enabled = false
                }
                focus: false
                enabled: false
                color: Root.State.colors.on_surface
                text: root.ws.name === root.ws.id.toString() ? "" : root.ws.name
                placeholderText: "Enter name..."
                Layout.fillWidth: true
                topInset: 2
                bottomInset: 2
                leftPadding: 10
                rightPadding: 10
                background: Rectangle {
                    color: nameField.enabled ? Root.State.colors.surface_container : "transparent"
                    border.color: nameField.enabled ? Root.State.colors.primary : "transparent"
                    radius: height
                }
                Keys.onReturnPressed: () => {
                    Hyprland.dispatch(`renameworkspace ${root.ws.id} ${text}`)
                    Hyprland.refreshWorkspaces() // TODO: Is this needed?
                    nameField.enabled = false
                }
            }
            Ctrls.Button {
                icon.name: "edit-clear-all-symbolic"
                onClicked: () =>  {
                    //nameField.text = ""
                    Hyprland.dispatch(`renameworkspace ${root.ws.id} ${root.ws.id}`)
                }
            }
            Ctrls.Button {
                icon.name: "edit-rename-symbolic"
                checked: nameField.enabled
                onClicked: () => {
                    nameField.enabled = !nameField.enabled
                    if (nameField.enabled) { nameField.focus = true }
                }
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
            if (root.ws.monitor === null) {
                return 0.5
            }
            return root.ws.monitor.height / root.ws.monitor.width
        }
        // Scale of virtual size to actual size
        property real widgetScale: {
            // This should only occur on initial startup, might be worth using a loader instead
            if (root.ws.monitor === null) {
                return 1
            }
            return widgetWidth / root.ws.monitor.width
        }
        implicitWidth: widgetWidth
        implicitHeight: Math.round(widgetWidth * aspectRatio)
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: (event) => {
            switch(event.button) {
                case Qt.LeftButton:
                    Hyprland.dispatch(`workspace ${root.ws.id}`) 
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
            implicitWidth: parent.width
            implicitHeight: parent.height
            radius: 8
            color: "transparent"//Root.State.colors.surface_container

            // TODO: Probably don't need loader here anymore
            Loader {
                anchors.fill: parent
                active: true
                property Component clients: Repeater {
                    model: Hyprland.toplevels.values.filter(toplevel => {
                        return toplevel.workspace !== null &&
                        toplevel.monitor !== null &&
                        toplevel.workspace.id === root.ws.id
                    })
                    // Each window in the workspace
                    Client {
                        required property HyprlandToplevel modelData
                        toplevel: modelData
                        clientObj: modelData.lastIpcObject
                        widgetScale: workspace.widgetScale
                        monitorScale: root.ws.monitor.scale
                        monitorX: root.ws.monitor.x
                        monitorY: root.ws.monitor.y
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
            keys: [ "workspace-client" ] // Drag source must have this key or it's ignored
            onDropped: (drop) => {
                // Apparently you need to cast the source type before you can use it 
                const clientObj = (drag.source as MouseArea).clientObj
                console.log(`dropped client with pid ${clientObj.pid} from ws ${clientObj.workspace.id}`)
                Hyprland.dispatch(`movetoworkspacesilent ${root.ws.id}, pid:${clientObj.pid}`)
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
