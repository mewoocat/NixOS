import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/" as Root
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
    width: content.width
    height: content.height
    content: GridLayout {
        // Assuming a max of 10 workspaces
        rows: 2
        columns: 5
        Repeater {
            model: 10
            Workspace {}
        }
    }
}

