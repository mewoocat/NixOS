import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/" as Root
import "root:/Services" as Services
import "root:/Modules" as Modules
import "root:/Modules/Ui" as Ui

Ui.PopupWindow {
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
        color: "transparent"
        implicitWidth: childrenRect.width + 20
        implicitHeight: childrenRect.height + 20
        GridLayout {
            anchors.centerIn: parent
            //anchors.margins: 20
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

