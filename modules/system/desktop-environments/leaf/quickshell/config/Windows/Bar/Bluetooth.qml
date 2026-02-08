import QtQuick
import Quickshell.Bluetooth

BarButton {
    visible: Bluetooth.defaultAdapter
    iconName: Bluetooth.defaultAdapter?.enabled ? "bluetooth-active" : "bluetooth-disabled"
    iconSize: 22
    leftClick: () => {
        console.log(Bluetooth.defaultAdapter)
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
    }
}
