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
        Button {
            onClicked: {
                console.log("bt devices " + Bluetooth.devices.values)
                console.log("bt adapters " + Bluetooth.adapters.values)
                console.log("bt state " + Bluetooth.defaultAdapter.state.toString())
            }
        }
        Switch {

        }
        ListView {
            implicitWidth: page.width
            implicitHeight: page.height
            model: Bluetooth.devices
            delegate: Common.NormalButton {
                id: device
                required property BluetoothDevice modelData
                text: device.modelData.name
            }
        }
    }
}
