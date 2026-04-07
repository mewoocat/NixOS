
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetData { 
    name: "Network (2x2)"
    xSize: 2
    ySize: 2
    component: ColumnLayout {
        id: root
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

            RoundButton {
                icon.name: rowItem.iconName
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
            iconName: "network-bluetooth-symbolic"
            normalAction: () => Root.State.controlPanelPage = 3
        }
    }
}
