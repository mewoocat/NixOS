import QtQuick
import QtQuick.Layouts
import "../../" as Root
import "../../Modules/Common" as Common

Common.PanelWindow {
    toggleWindow: () => {
        Root.State.workspacesVisibility = !Root.State.workspacesVisibility
    } 
    closeWindow: () => {
        Root.State.workspacesVisibility = false
    } 
    name: "workspaces"
    visible: Root.State.workspacesVisibility
    anchors {}
    implicitWidth: content.width
    implicitHeight: content.height
    content: Rectangle {
        id: padding
        property int margins: 10
        color: "transparent"
        implicitWidth: grid.width + padding.margins * 2
        implicitHeight: grid.height + padding.margins * 2
        GridLayout {
            id: grid
            x: padding.margins
            y: padding.margins
            // Assuming a max of 10 workspaces
            rows: 3
            columns: 4
            Repeater {
                model: 10
                Workspace {
                    required property int modelData
                    wsId: modelData + 1
                    //monitor: 
                    Component.onCompleted: {
                        //console.log(`modelData: ${modelData}`)
                        //console.log(`workspace map for ${Services.Hyprland.workspaceMap[modelData]}`)
                    }
                }
            }
        }
    }
}

