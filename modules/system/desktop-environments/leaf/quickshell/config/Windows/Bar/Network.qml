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
                        checked: Networking.wifiEnabled ?? false
                        onClicked: Networking.wifiEnabled = checked
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
                visible: Services.Networking.currentWifiNetwork != null
                Shared.TextBlock {
                    text: "Connected Network"
                    font.bold: true
                }
            }
            Ctrls.MenuItem {
                visible: Services.Networking.currentWifiNetwork != null
                property WifiNetwork wifiNet: Services.Networking.currentWifiNetwork
                text: wifiNet?.name
                icon.name: Services.Networking.getWifiAPIconName(wifiNet)
                Layout.fillWidth: true
            }

            RowLayout {
                Shared.TextBlock {
                    text: "Nearby Networks"
                    font.bold: true
                }
                Item { Layout.fillWidth: true }
                Ctrls.Button {
                    icon.name: "view-refresh-symbolic"
                    icon.width: 16
                    icon.height: 16
                    onClicked: () => Services.Networking.wifiInterface.scannerEnabled = true
                    color: Services.Networking.wifiInterface.scannerEnabled ? "red" : "blue"
                }
            }

            Shared.ScrollableList {
                model: Services.Networking.wifiDisconnectedNetworks
                Layout.preferredHeight: implicitHeight < 200 ? implicitHeight : 200
                Layout.fillWidth: true
                delegate: Ctrls.MenuItem {
                    required property WifiNetwork modelData
                    text: modelData?.name
                    icon.name: Services.Networking.getWifiAPIconName(modelData)
                    width: parent.width
                    onClicked: () => {
                        Root.State.promptStack.push(apPrompt)
                    }
                    property Component apPrompt: ColumnLayout {
                        Shared.TextBlock {
                            text: "Connect to Network"
                        }
                        Ctrls.TextField {

                        }
                        Ctrls.Button {
                            text: "Cancel"
                            onClicked: Root.State.promptStack.pop()
                        }
                    }

                }
            }

            Shared.Seperator {
                implicitHeight: 8
                Layout.fillWidth: true
            }

            Ctrls.MenuItem {
                text: "Wifi Settings"
                Layout.fillWidth: true
            }
        }
    }
}
