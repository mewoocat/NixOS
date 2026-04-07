pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

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

                signal normalAction()
                signal toggleAction()

                Layout.fillWidth: true
                Layout.fillHeight: true

                RoundButton {
                    icon.name: rowItem.iconName
                    onClicked: rowItem.toggleAction()
                }
                WrapperMouseArea {
                    id: mouseArea
                    enabled: true
                    hoverEnabled: true
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: rowItem.normalAction()
                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: root.anchors.topMargin / 2
                        anchors.bottomMargin: root.anchors.topMargin / 2
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
            // Internet
            RowItem {
                title: "Wifi"
                subtext: "my-ssid"
                iconName: "network-wireless-symbolic"
                onNormalAction: () => Root.State.controlPanelPage = 2
            }
            // Bluetooth
            RowItem {
                title: "Bluetooth"
                subtext: "my-device"
                iconName: "network-bluetooth-symbolic"
                onNormalAction: () => Root.State.controlPanelPage = 3
            }
        }
    }
}
