pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Shared as Shared
import Quickshell.Bluetooth

import "../Pages" as Pages

AbsGrid.WidgetData { 
    id: widgetData
    name: "Network"
    xSize: 2
    ySize: 2
    component: Item {
        id: root
        anchors.fill: parent
        anchors.margins: widgetData.radius
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            component RowItem: RowLayout {
                id: rowItem
                required property string iconName
                required property string title
                required property string subtext
                required property Component content

                property bool active: false
                signal normalAction()
                signal toggleAction()

                function goBack() {
                    expander.expanded = false
                }

                Layout.fillWidth: true
                Layout.fillHeight: true

                Ctrls.RoundButton {
                    icon.name: rowItem.iconName
                    onClicked: rowItem.toggleAction()
                    backgroundColor: rowItem.active || hovered ? Root.State.colors.primary : Root.State.colors.surface_container_highest
                    color: rowItem.active || hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
                }
                MouseArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: mouseArea
                    enabled: true
                    hoverEnabled: true
                    onClicked: expander.expanded = true
                    Shared.Expander {
                        id: expander
                        anchors.fill: parent
                        backgroundRadius: widgetData.radius
                        backgroundMargin: widgetData.padding
                        backdrop: widgetData.panelGrid
                        content: rowItem.content
                        expandee: Rectangle {
                            anchors.fill: parent
                            anchors.topMargin: root.anchors.topMargin
                            anchors.bottomMargin: root.anchors.topMargin
                            radius: Root.State.smallRounding
                            color: mouseArea.containsMouse ? Root.State.colors.primary : "transparent"
                            Item {
                                anchors.fill: parent
                                anchors.margins: 4
                                ColumnLayout {
                                    anchors.verticalCenter: parent.verticalCenter
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
                }
            }
            // Internet
            RowItem {
                id: internet
                title: "Wifi"
                subtext: Services.Networking.currentWifiNetwork.name
                iconName: Services.Networking.currentWifiIconName
                content: null
                /*
                content: Pages.Network {
                    onGoBack: internet.goBack()
                }
                */
                active: Services.Networking.isWifiEnabled
                onToggleAction: Services.Networking.setWifiEnabled(!Services.Networking.isWifiEnabled)
            }
            // Bluetooth
            RowItem {
                id: bluetooth
                title: "Bluetooth"
                subtext: "my-device"
                iconName: "network-bluetooth-symbolic"
                content: Pages.Bluetooth {
                    onGoBack: bluetooth.goBack()
                }
                active: Bluetooth.defaultAdapter.enabled
                onToggleAction: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
            }
        }
    }
}
