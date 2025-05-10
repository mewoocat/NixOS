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
        implicitWidth: parent.width
        implicitHeight: parent.height
        columns: 2
        rows: 4
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
