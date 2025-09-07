pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Modules.Common as Common

Common.FullscreenWindow {
    id: root
    toggleWindow: () => {
        Root.State.workspacesVisibility = !Root.State.workspacesVisibility
    } 
    closeWindow: () => {
        Root.State.workspacesVisibility = false
    } 
    name: "workspaces"
    visible: Root.State.workspacesVisibility
    implicitWidth: content.width
    implicitHeight: content.height
    content: MouseArea {
        id: padding
        anchors.fill: parent
        onClicked: () => root.closeWindow()
        enabled: true
        hoverEnabled: true
        GridLayout {
            anchors.centerIn: parent
            id: grid
            // Assuming a max of 10 workspaces
            rows: 3
            columns: 4
            rowSpacing: 32
            columnSpacing: 32
            Repeater {
                model: 10
                Workspace {
                    required property int modelData
                    wsId: modelData + 1
                    widgetWidth: root.width / (grid.columns + 1)
                }
            }
        }
    }
}

