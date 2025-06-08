import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../"
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules" as Modules
import "../../../Modules/Common" as Common

Common.PanelGrid {
    columns: 4
    //rows: 4

    //PanelItem { Layout.columnSpan: 2; iconName: "ymuse-home-symbolic"}
    Common.PanelItem { 
        rows: 2
        columns: 2
        //action: () => {grid.height = grid.height + 100}
        action: () => {
            console.log("clicked")
            Root.State.controlPanelPage = 1
        }
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
    }


    Common.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
    }
    Common.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
    }
    Common.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
        action: () => {
            console.log('action:')
            console.log(Root.State.config.location.latitude)
            Root.State.config.location.latitude = 3
            console.log(Root.State.config.location.latitude)
        }
    }
    Common.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
    }

    Common.PanelItem { 
        rows: 2
        columns: 2
        isClickable: false
        content: Modules.SystemStats {
        }
    }
    Common.PanelItem { 
        rows: 2
        columns: 2
        content: ComboBox {
            model: ["First", "Second", "Third"]
        }
    }

    Common.PanelItem { 
        content: SliderPanel {}
        isClickable: false
        rows: 2
        columns: 4
    }


    /*
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    */
}
