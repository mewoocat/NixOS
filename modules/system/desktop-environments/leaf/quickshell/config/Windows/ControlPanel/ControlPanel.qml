//pragma Singleton
import "root:/Modules/Ui" as Ui
import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/" as Root

Ui.PopupWindow {
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility
    function toggleWindow(){
        console.log("toggle window")
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 
    anchors {
        top: true
        right: true
    }
    content: GridLayout {
        columns: 4
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
