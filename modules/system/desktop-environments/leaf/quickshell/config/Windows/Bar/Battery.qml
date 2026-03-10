import QtQuick
import Quickshell.Services.UPower

BarButton {
    visible: UPower.displayDevice.type !== UPowerDeviceType.Unknown
    icon.name: UPower.displayDevice.iconName
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
