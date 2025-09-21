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
        required property var modelData
        onClicked: () => modelData.connect()
        content: RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            implicitWidth: 60
            implicitHeight: 24
            spacing: 8
            IconImage {
                Layout.leftMargin: 8
                implicitSize: 18
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
                Text {
                    id: status
                    Layout.fillWidth: true
                    color: palette.placeholderText
                    elide: Text.ElideRight
                    font.pointSize: 8
                    text: device.modelData.paired ? BluetoothDeviceState.toString(device.modelData.state) : "Not paired"
                }
            }
            Common.NormalButton {
                Layout.alignment: Qt.AlignRight
                iconName: "settings"
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
                spacing: 0

                Item {
                    Layout.fillWidth: true
                    implicitHeight: section.height
                    Text {
                        id: section
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
                    delegate: BTDevice {}
                }

                RowLayout {

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 20
                        Text {
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
                    delegate: BTDevice {}
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
                Item {implicitHeight: 128; Layout.fillWidth: true}
            }
        }
    }
}
