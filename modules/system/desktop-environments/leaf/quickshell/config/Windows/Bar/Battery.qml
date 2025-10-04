import QtQuick
import Quickshell.Services.UPower

BarButton {
    visible: UPower.displayDevice.type !== UPowerDeviceType.Unknown
    action: () => {}
    iconName: UPower.displayDevice.iconName
    iconSize: 18
    recolorIcon: true
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
