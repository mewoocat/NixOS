import QtQuick
import Quickshell.Services.UPower
import "../../Modules/Common" as Common

Common.NormalButton {
    action: () => {}
    isClickable: false
    iconName: UPower.displayDevice.iconName
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
