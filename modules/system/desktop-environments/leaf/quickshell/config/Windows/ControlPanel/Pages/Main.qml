import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
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
            source: `file://${Quickshell.configDir}/Icons/nightlight-symbolic.svg` // For some reason configDir exists but shellRoot doesn't

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
            source: Quickshell.iconPath("color-profile")
        }
    }
    Common.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("media-record-symbolic")
            // Recolor
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1 // Full re-color
                colorizationColor: "#ee1111"
            }
        }
        action: () => {
        }
    }
    Common.PanelItem { 
        id: testPanelItem
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("power-profile-balanced-symbolic")
        }
        action: () => {
            console.log("action")
            powerProfilePopup.visible = true
        }
        //TODO: The reason this triggers the focus grab for the parent window is because the panelGrab state is set again for each
        // Common.PanelWindow created.  Need to store the references in the state using a map or something
        // also, commenting out the launcher in the shell.qml allows for this popup to work
        Common.PopupWindow {
            id: powerProfilePopup
            
            anchor {
                //window: Root.State.controlPanel
                item: testPanelItem
                edges: Edges.Bottom | Edges.Left
                gravity: Edges.Top | Edges.Left
            }

            content: ColumnLayout {
                Text { color: palette.text; text: "wtf" }
            }
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
        content: ColumnLayout {
            Text {
                color: palette.text
                //text: "what: " + Services.Power.currentProfile
                text: {
                    return "profile: " + PowerProfile.toString(PowerProfiles.profile)
                }
            }
            ComboBox {
                model: ["First", "Second", "Third"]
            }
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
