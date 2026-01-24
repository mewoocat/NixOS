import QtQuick
import Quickshell.Networking

BarButton {
    property NetworkDevice nic: Networking.devices.values.find(device => device.type === DeviceType.Wifi)
    iconSize: 24
    text: `dev ${nic}`
    iconName: "network-wireless-connected-75"
}
