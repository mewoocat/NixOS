pragma ComponentBehavior: Bound // allows for referencing of siblings
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Common as Common

PageBase {
    id: page
    pageName: "Bluetooth"
    headerContent: RowLayout {
        Switch {

        }
        IconImage {
            implicitSize: 18
            source: Quickshell.iconPath("bluetooth")
        }
    }
    
    component BTDevice: Common.ScrollableItem {
        id: device
        required property BluetoothDevice modelData
        onClicked: {
            if (device.expanded) {
                return device.toggleExpand()
            }
            if (modelData.paired) {
                return modelData.connected ? modelData.disconnect() : modelData.connect()
            }
            return modelData.pair()
        }
        content: RowLayout {
            spacing: 8
            IconImage {
                Layout.leftMargin: 4
                implicitSize: 24
                source: Quickshell.iconPath(device.modelData.icon, "bluetooth") // fallbacks to "bluetooth"
            }
            ColumnLayout {
                spacing: 0
                Text {
                    id: name
                    Layout.fillWidth: true
                    color: palette.text
                    elide: Text.ElideRight
                    text: device.modelData.name
                }
                RowLayout {
                    Text {
                        id: status
                        color: palette.placeholderText
                        elide: Text.ElideRight
                        font.pointSize: 8
                        text: device.modelData.paired ? BluetoothDeviceState.toString(device.modelData.state) : "Not paired"
                    }
                    RowLayout {
                        spacing: 0
                        visible: device.modelData.batteryAvailable
                        IconImage {
                            implicitSize: 12
                            source: Quickshell.iconPath("battery-100-symbolic")
                        }
                        Text {
                            id: battery
                            Layout.fillWidth: true
                            color: palette.placeholderText
                            elide: Text.ElideRight
                            font.pointSize: 8
                            text: device.modelData.batteryAvailable ? (device.modelData.battery * 100) + ' %' : "n/a"
                        }
                    }
                }
            }
            Common.NormalButton {
                Layout.alignment: Qt.AlignRight
                iconName: "view-more"
                leftClick: device.toggleExpand
            }
        }
        subContent: ColumnLayout {
            width: 100
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Common.NormalButton {
                    visible: device.modelData.paired
                    text: device.modelData.connected ? "disconnect" : "connect"
                    leftClick: device.modelData.connected ? device.modelData.disconnect : device.modelData.connect
                }
                Common.NormalButton {
                    text: device.modelData.paired ? "forget" : "pair"
                    leftClick: device.modelData.paired ? device.modelData.forget : device.modelData.pair
                }
            }
            Text {
                Layout.fillWidth: true
                color: palette.text
                font.pointSize: 10
                wrapMode: Text.Wrap
                text: "name: " + device.modelData.deviceName
            }
            Text {
                Layout.fillWidth: true
                color: palette.text
                font.pointSize: 10
                wrapMode: Text.Wrap
                text: "address: " + device.modelData.address
            }
            Text {
                Layout.fillWidth: true
                color: palette.text
                font.pointSize: 10
                wrapMode: Text.Wrap
                text: "battery info available: " + device.modelData.batteryAvailable
            }
        }
    }

    content: ColumnLayout {
        anchors.fill: parent

        Common.VScrollable {
            id: scrollable
            padding: 0
            Layout.fillWidth: true; Layout.fillHeight: true
        
            content: ColumnLayout {
                id: col
                spacing: 4

                WrapperItem {
                    Layout.fillWidth: true
                    Text {
                        padding: 8
                        color: palette.text
                        text: "My Devices"
                    }
                }
                Common.HorizontalLine { Layout.rightMargin: 20 }
                Repeater {
                    Component.onCompleted: console.log(`repeater width: ${width}`)
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => device.paired)
                    }
                    delegate: BTDevice {
                        parentScrollable: scrollable
                    }
                }

                RowLayout {

                    WrapperItem {
                        Layout.fillWidth: true
                        Text {
                            padding: 8
                            color: palette.text
                            text: "Nearby Devices"
                        }
                    }
                    Button {
                        Layout.rightMargin: 8 // TODO: find a better solution
                        id: refreshButton
                        icon.name: "view-refresh-symbolic" 
                        onClicked: {
                           console.log(`scannings for bt devices`)
                           Bluetooth.defaultAdapter.discovering = true
                        }
                    }
                }
                Common.HorizontalLine { Layout.rightMargin: 20 }
                Repeater {
                    model: ScriptModel {
                        values: Bluetooth.devices.values.filter(device => !device.paired)
                    }
                    delegate: BTDevice {
                        parentScrollable: scrollable
                    }
                }
                Item {
                    id: nearbyFallback
                    visible: !Bluetooth.devices.values.some(device => !device.paired)
                    Layout.fillWidth: true
                    implicitHeight: 64
                    Text {
                        anchors.centerIn: parent
                        color: palette.placeholderText
                        text: "Refresh to scan for new devices"
                        font.pointSize: 10
                    }
                }
            }
        }
    }
}
