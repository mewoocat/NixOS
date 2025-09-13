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
            delegate: Rectangle {
                required property var modelData
                implicitWidth: 120
                implicitHeight: 100

                color: "red"
                Text {
                    Layout.alignment: Qt.AlignLeft
                    leftPadding: 4
                    color: palette.text
                    text: modelData.name
                }
            }
        }
    }
}
