import "root:/Modules/Ui" as Ui
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
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
        columnSpacing: 0
        rowSpacing: 0
        implicitWidth: parent.width
        implicitHeight: (parent.width / rows) * columns
        columns: 2
        rows: 2

        //PanelItem { Layout.columnSpan: 2; iconName: "ymuse-home-symbolic"}
        PanelItem { 
            action: () => {}
            content: IconImage {
                anchors.centerIn: parent
                implicitSize: 32
                source: Quickshell.iconPath("ymuse-home-symbolic")
            }
        }

        PanelItem { 
            action: () => {}
            content: SliderPanel {}
            Layout.columnSpan: 2;
        }


        /*
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        PanelItem { iconName: "ymuse-home-symbolic"}
        */
    }

}
