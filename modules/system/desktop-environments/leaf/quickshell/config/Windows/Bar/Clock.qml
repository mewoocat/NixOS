import QtQuick
import "../../" as Root
import "../../Singletons" as Sin
import "../../Modules/Common" as Common

Common.NormalButton {
    leftClick: () => Root.State.activityCenter.toggleWindow()
    //iconName: "security-low"
    text: Sin.Time.time
}
