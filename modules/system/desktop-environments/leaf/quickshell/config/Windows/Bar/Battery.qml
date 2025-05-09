import QtQuick
import Quickshell.Services.UPower
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Ui.NormalButton {
    action: () => {}
    isClickable: false
    iconName: UPower.displayDevice.iconName
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`
}
