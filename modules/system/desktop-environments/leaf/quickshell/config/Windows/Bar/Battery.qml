import QtQuick
import Quickshell.Services.UPower
import "../../Modules/Common" as Common

BarButton {
    action: () => {}
    //isClickable: false
    iconName: UPower.displayDevice.iconName
    iconSize: 26
    recolorIcon: true
    Component.onCompleted: console.log(iconName)
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
