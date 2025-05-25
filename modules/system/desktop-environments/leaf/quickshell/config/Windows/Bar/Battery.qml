import QtQuick
import Quickshell.Services.UPower
import "root:/Modules/Common" as Common
import "root:/" as Root

Common.NormalButton {
    action: () => {}
    isClickable: false
    iconName: UPower.displayDevice.iconName
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
