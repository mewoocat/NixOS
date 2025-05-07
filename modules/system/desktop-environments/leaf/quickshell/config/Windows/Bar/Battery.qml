import QtQuick
import Quickshell.Services.UPower
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Ui.NormalButton {
    action: () => {}
    iconName: "battery-070-charging"
    text: `${UPower.displayDevice.percentage * 100}%`
}
