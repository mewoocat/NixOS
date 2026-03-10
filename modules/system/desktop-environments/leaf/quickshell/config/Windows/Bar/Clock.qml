import QtQuick
import qs as Root
import qs.Services as Services

BarButton {
    onClicked: () => Root.State.activityCenter.toggleWindow()
    text:  Services.Time.time
}
