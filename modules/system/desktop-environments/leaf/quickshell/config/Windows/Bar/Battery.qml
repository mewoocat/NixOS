import QtQuick
import Quickshell.Services.UPower
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Ui.NormalButton {
    action: () => {}
    iconName: UPower.displayDevice.iconName
    //text: `${UPower.displayDevice.percentage * 100}`
    text: UPower.displayDevice.percentage.toString()
}
