import QtQuick
import Quickshell.Services.UPower

BarButton {
    visible: UPower.displayDevice.type !== UPowerDeviceType.Unknown
    action: () => {}
    //isClickable: false
    iconName: UPower.displayDevice.iconName
    iconSize: 26
    recolorIcon: true
    Component.onCompleted: console.log(iconName)
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
