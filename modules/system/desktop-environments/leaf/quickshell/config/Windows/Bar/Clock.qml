import QtQuick
import qs as Root
import qs.Services as Services

BarButton {
    leftClick: () => Root.State.activityCenter.toggleWindow()
    //iconName: "security-low"
    text:  Services.Time.time
}
