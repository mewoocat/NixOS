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
    pageName: "Bluetooth New"
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
        Common.ListViewScrollable {
            Layout.fillWidth: true; Layout.fillHeight: true
            model: Bluetooth.devices
            delegate: Common.ScrollableItem {
                id: device
                required property var modelData
                content: RowLayout {
                    implicitHeight: 32
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
