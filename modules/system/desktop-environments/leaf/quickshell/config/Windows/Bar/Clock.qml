import QtQuick
import qs as Root
import qs.Services as Services

BarButton {
    onClicked: () => {
        const prevActiveState = Root.State.activityCenterActive
        Root.State.closeAll()
        Root.State.activityCenterActive = !prevActiveState
    }
    text:  Services.DateTime.date + '  ' + Services.DateTime.time
}
