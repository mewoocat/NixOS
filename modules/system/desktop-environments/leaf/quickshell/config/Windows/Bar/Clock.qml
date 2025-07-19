import QtQuick
import "../../" as Root
import "../../Singletons" as Sin
import "../../Modules/Common" as Common

BarButton {
    leftClick: () => Root.State.activityCenter.toggleWindow()
    //iconName: "security-low"
    text:  Sin.Time.time
}
