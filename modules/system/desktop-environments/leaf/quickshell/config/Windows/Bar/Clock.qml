import QtQuick
import qs as Root
import qs.Services as Services

BarButton {
    onClicked: () => Root.State.activityCenterActive = !Root.State.activityCenterActive
    text:  Services.Time.time
}
