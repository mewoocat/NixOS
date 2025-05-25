import QtQuick
import "root:/" as Root
import "root:/Singletons" as Sin
import "root:/Modules/Common" as Common

Common.NormalButton {
    leftClick: () => Root.State.activityCenter.toggleWindow()
    iconName: "security-low"
    text: Sin.Time.time
}
