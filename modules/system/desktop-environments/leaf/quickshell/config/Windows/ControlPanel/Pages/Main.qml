import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
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
    //width: 400
    //height: 400

    Component.onCompleted: console.log(`panel grid: ${width}x${height}`)

    //PanelItem { Layout.columnSpan: 2; iconName: "ymuse-home-symbolic"}
    Common.PanelItem { 
        rows: 2
        columns: 2
        //action: () => {grid.height = grid.height + 100}
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("ymuse-home-symbolic")
        }
        action: () => {
            Root.State.controlPanelPage = 2
        }
    }


    Common.PanelItem { 
        rows: 1
        columns: 1
        action: () => Services.NightLight.toggle()
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: `file://${Quickshell.shellRoot}/Icons/nightlight-symbolic.svg`

            // Recolor
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1 // Full re-color
                colorizationColor: palette.text
            }
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
