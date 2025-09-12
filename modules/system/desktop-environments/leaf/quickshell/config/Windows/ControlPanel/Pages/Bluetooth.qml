import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Common as Common

PageBase {
    id: page
    pageName: "Bluetooth"
    content: ColumnLayout {
        anchors.fill: parent
        Button {
            onClicked: {
                console.log("bt devices " + Bluetooth.devices.values)
                console.log("bt adapters " + Bluetooth.adapters.values)
                console.log("bt state " + Bluetooth.defaultAdapter.state.toString())
            }
        }
        Switch {

        }
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: palette.base
            radius: 8

            ListView {
                anchors.fill: parent
                model: Bluetooth.devices
                delegate: MouseArea {
                    id: device
                    required property BluetoothDevice modelData
                    enabled: true; hoverEnabled: true
                    implicitWidth: parent.width
                    implicitHeight: 48

                    Rectangle {
                        anchors.fill: parent
                        color: device.containsMouse ? palette.highlight : "transparent"
                        radius: 16
                        RowLayout {
                            anchors.fill: parent
                            Text {
                                Layout.alignment: Qt.AlignLeft
                                leftPadding: 4
                                color: palette.text
                                text: device.modelData.name
                            }
                            Common.NormalButton {
                                Layout.alignment: Qt.AlignRight
                                iconName: "settings"
                            }
                        }
                    }
                }
            }
        }
    }
}
