import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import "../"
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules" as Modules
import "../../../Modules/Common" as Common

Common.PanelGrid {
    columns: 4
    rows: 4

    Common.PanelItem { 
        rows: 2
        columns: 2
        isClickable: false
        action: () => {
            Root.State.controlPanelPage = 2
        }
        
        //action: () => {grid.height = grid.height + 100}
        content: ColumnLayout {
            anchors.margins: 12
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            component RowItem: RowLayout {
                id: rowItem
                required property string iconName
                required property string title
                required property string subtext
                property var toggleAction: () => {}
                property var normalAction: () => {}

                Layout.fillWidth: true
                Layout.fillHeight: true
                RoundButton {
                    icon.name: rowItem.iconName
                    icon.height: 16
                    icon.width: 16
                }
                WrapperMouseArea {
                    id: mouseArea
                    enabled: true
                    hoverEnabled: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    WrapperRectangle {
                        //anchors.verticalCenter: parent.verticalCenter // Doesn't seem to do anything lol
                        //anchors.left: parent.left
                        radius: Root.State.rounding 
                        color: mouseArea.containsMouse ? palette.accent : "transparent"
                        margin: 4
                        ColumnLayout {
                            spacing: 0
                            Text {
                                color: palette.text;
                                text: rowItem.title
                                font.pointSize: 10
                            }
                            Text { 
                                color: palette.placeholderText;
                                text: rowItem.subtext
                                font.pointSize: 8
                            }
                        }
                    }
                }
            }
            // Internet
            RowItem {
                title: "Wifi"
                subtext: "my-ssid"
                iconName: "network-wireless-symbolic"
            }
            // Bluetooth
            RowItem {
                title: "Bluetooth"
                subtext: "my-device"
                iconName: "network-bluetooth"
            }
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
        isClickable: false
        rows: 2
        columns: 2
        content: ColumnLayout {
            /*
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
            */
        }
    }

    Common.PanelItem { 
        isClickable: false
        rows: 2
        columns: 4
        content: WrapperRectangle {
            anchors.fill: parent
            color: "transparent"
            margin: 8

        ColumnLayout {    
            //anchors.fill: parent
            RowLayout {
                Common.NormalButton {
                    iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
                    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
                    leftClick: () => {
                        console.log("clicked")
                        Root.State.controlPanelPage = 1
                    }
                    Layout.minimumWidth: 86
                }
                Slider {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    stepSize: 0.01
                    from: 0
                    value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
                    onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
                    to: 1
                }
            }

            RowLayout {
                Common.NormalButton {
                    iconName: Services.Brightness.getIcon()
                    text: Math.ceil(Services.Brightness.value * 100) + '%'
                    leftClick: () => {
                        console.log("clicked")
                        Root.State.controlPanelPage = 1
                    }
                    Layout.minimumWidth: 86
                }
                Slider {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    from: 0.01
                    value: Services.Brightness.value
                    stepSize: 0.01
                    onValueChanged: {
                        Services.Brightness.value = value
                    }
                    to: 1
                }
            }
        }
        }
    }

    /*
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    PanelItem { iconName: "ymuse-home-symbolic"}
    */
}
