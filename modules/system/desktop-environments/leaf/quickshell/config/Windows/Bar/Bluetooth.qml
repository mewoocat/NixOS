import QtQuick
import Quickshell.Bluetooth

BarButton {
    visible: Bluetooth.defaultAdapter
    icon.name: Bluetooth.defaultAdapter?.enabled ? "network-bluetooth-symbolic" : "network-bluetooth-inactive-symbolic"
    onClicked: () => Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
}
