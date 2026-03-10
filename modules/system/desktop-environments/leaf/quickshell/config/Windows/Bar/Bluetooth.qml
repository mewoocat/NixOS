import QtQuick
import Quickshell.Bluetooth

BarButton {
    visible: Bluetooth.defaultAdapter
    icon.name: Bluetooth.defaultAdapter?.enabled ? "bluetooth-active" : "bluetooth-disabled"
    onClicked: () => Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
    isMutliColorIcon: true
}
