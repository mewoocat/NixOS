import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import qs as Root
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf

Leaf.PanelGrid {
    columns: 4
    rows: 4

    Leaf.PanelItem { 
        rows: 2
        columns: 2
        isClickable: false
        action: () => {
            Root.State.controlPanelPage = 2
        }
        
        //action: () => {grid.height = grid.height + 100}
        content: ColumnLayout {
            anchors.margins: 8
            spacing: 16
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

                Leaf.CircleButton {
                    iconName: rowItem.iconName
                }
                WrapperMouseArea {
                    id: mouseArea
                    enabled: true
                    hoverEnabled: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: normalAction()
                    WrapperRectangle {
                        //anchors.verticalCenter: parent.verticalCenter // Doesn't seem to do anything lol
                        //anchors.left: parent.left
                        radius: Root.State.rounding 
                        color: mouseArea.containsMouse ? Root.State.colors.primary : "transparent"
                        margin: 4
                        ColumnLayout {
                            spacing: 0
                            Text {
                                color: mouseArea.containsMouse ? Root.State.colors.on_primary : Root.State.colors.on_surface
                                text: rowItem.title
                                font.pointSize: 10
                            }
                            Text { 
                                color: mouseArea.containsMouse ? Root.State.colors.on_primary : Root.State.colors.on_surface
                                opacity: 0.6
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
                normalAction: () => Root.State.controlPanelPage = 2
            }
            // Bluetooth
            RowItem {
                title: "Bluetooth"
                subtext: "my-device"
                iconName: "network-bluetooth"
                normalAction: () => Root.State.controlPanelPage = 3
            }
        }
    }


    Leaf.PanelItem { 
        rows: 1
        columns: 1
        action: () => Services.NightLight.toggle()
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: `file://${Quickshell.shellDir}/Icons/nightlight-symbolic.svg` // For some reason configDir exists but shellRoot doesn't

            // Recolor
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1 // Full re-color
                colorizationColor: palette.text
            }
        }
    }
    Leaf.PanelItem { 
        rows: 1
        columns: 1
        content: IconImage {
            anchors.centerIn: parent
            implicitSize: 32
            source: Quickshell.iconPath("color-profile")
        }
    }
    Leaf.PanelItem { 
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
    Leaf.PanelItem { 
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
        // Leaf.PanelWindow created.  Need to store the references in the state using a map or something
        // also, commenting out the launcher in the shell.qml allows for this popup to work
        Leaf.PopupWindow {
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

    Leaf.PanelItem { 
        rows: 2
        columns: 2
        isClickable: false
        content: Modules.SystemStats {
        }
    }
    Leaf.PanelItem { 
        isClickable: false
        rows: 2
        columns: 2
        content: RowLayout {
            anchors.centerIn: parent
            spacing: 0

            Slider {
                orientation: Qt.Vertical
                from: 0
                to: 2
                stepSize: 1
                snapMode: Slider.SnapOnRelease
                implicitHeight: powerProfileList.height
                value: PowerProfiles.profile // 0 - PowerSaver, 1 - Balanced, 2 - Perfomance
                onValueChanged: PowerProfiles.profile = value
            }
            ColumnLayout {
                id: powerProfileList
                spacing: 0
                Leaf.NormalButton {
                    visible: PowerProfiles.hasPerformanceProfile
                    //Layout.fillWidth: true
                    text: "Performance"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.Performance
                    highlight: PowerProfiles.profile == PowerProfile.Performance
                }
                Leaf.NormalButton {
                    //Layout.fillWidth: true
                    text: "Balanced"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.Balanced
                    highlight: PowerProfiles.profile == PowerProfile.Balanced
                }
                Leaf.NormalButton {
                    //Layout.fillWidth: true
                    text: "Low Power"
                    fontSize: 10
                    buttonHeight: 32
                    leftClick: () => PowerProfiles.profile = PowerProfile.PowerSaver
                    highlight: PowerProfiles.profile == PowerProfile.PowerSaver
                }
            }

            //BusyIndicator {}
            //Dial {}
            /*
            Text {
                color: palette.text
                //text: "what: " + Services.Power.currentProfile
                text: {
                    return "profile: " + PowerProfile.toString(PowerProfiles.profile)
                }
            }
            */
        }
    }

    Leaf.PanelItem { 
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
                Leaf.NormalButton {
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
                    //stepSize: 0.01
                    from: 0
                    value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
                    onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
                    to: 1
                }
            }

            RowLayout {
                Leaf.NormalButton {
                    iconName: Services.Brightness.getIcon()
                    text: Math.ceil(Services.Brightness.value * 100) + '%'
                    leftClick: () => {
                        console.log("clicked")
                        Root.State.controlPanelPage = 4
                    }
                    Layout.minimumWidth: 86
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.01
                    value: Services.Brightness.value
                    //stepSize: 0.01
                    onValueChanged: {
                        Services.Brightness.value = value
                    }
                    to: 1
                }
            }
        }
        }
    }
}
