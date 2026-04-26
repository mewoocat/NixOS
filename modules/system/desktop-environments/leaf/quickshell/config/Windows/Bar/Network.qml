
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import QtQuick
import qs.Services as Services

BarButton {
    id: buttonRoot
    visible: Services.Networking.networkInterfaces
    icon.name: Services.Networking.getWifiActiveIconName(Services.Networking.currentWifiNetwork)
    ContextMenu.onRequested: () => popupWindow.visible = true

    property Shared.PopupWindow popupWindow: Shared.PopupWindow {
        id: root
        property Item parentButton: buttonRoot // The button that this popup will be relative to

        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            item: parentButton
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Bottom | Edges.Left
        }

        content: ColumnLayout {
            id: menuContent
            spacing: 0

            ColumnLayout {
                //Layout.minimumWidth: 240
                RowLayout {
                    Shared.TextBlock {
                        text: "Wi-Fi"
                        font.bold: true
                    }
                    Item { Layout.fillWidth: true }
                    Switch {
                    }
                }
                ColumnLayout {
                    Shared.TextBlock {
                        text:
                            "Interface Name:  " + Services.Networking.wifiInterface?.name + "\n"
                            + "Mac address:  " + Services.Networking.wifiInterface?.address
                        font.pointSize: 10 
                        opacity: 0.6
                    }
                }
            }

            Shared.Seperator {
                implicitHeight: 8
                Layout.fillWidth: true
            }

            RowLayout {
                Shared.TextBlock {
                    text: "Networks"
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Ctrls.Button {
                    icon.name: "view-refresh-symbolic"
                    icon.width: 16
                    icon.height: 16
                    onClicked: () => Services.Networking.wifiInterface.scannerEnabled = true
                }
            }

            Repeater {
                model: Services.Networking.wifiInterface.networks
                /*
                Ctrls.MenuItem {
                    required property WifiNetwork modelData
                    text: modelData?.name
                    icon.name: "network-wireless-100-connected-symbolic"//Services.Networking.getWifiAPIconName(modelData)
                    //icon.name: "view-refresh-symbolic"
                    Layout.fillWidth: true
                    Component.onCompleted: console.log(`network completed`)
                }
                */
                Ctrls.Button {
                    required property WifiNetwork modelData
                    text: modelData?.name
                    icon.name: "network-wireless-connected-100-symbolic"//Services.Networking.getWifiAPIconName(modelData)
                    Layout.fillWidth: true
                }
            }
        }
    }
}
