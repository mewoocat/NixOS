import QtQuick
import "../../" as Root
import "../../Services/" as Services

BarButton {
    leftClick: () => Root.State.activityCenter.toggleWindow()
    //iconName: "security-low"
    text:  Services.Time.time
}
