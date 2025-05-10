//pragma Singleton
import "root:/Modules/Ui" as Ui
import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/" as Root

Ui.PopupWindow {
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility
    width: 300
    height: content.height
    toggleWindow: () => {
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 
    closeWindow: () => {
        Root.State.controlPanelVisibility = false
    } 
    anchors {
        top: true
        right: true
    }
    content: GridLayout {
        //uniformCellWidths: true
        //uniformCellHeights: true
        width: parent.width
        height: rows * (parent.width / columns)
        columns: 4
        rows: 3
        rowSpacing: 0
        columnSpacing: 0
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}

        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}

        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
    }

}
