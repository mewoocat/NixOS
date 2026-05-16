pragma ComponentBehavior: Bound

import QtQuick
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

AbsGrid.WidgetData { 
    id: widgetData
    name: "Screen Capture (1x1)"
    xSize: 1
    ySize: 1
    //active: Services.ScreenCapture.recording
    showBackground: false
    component: Ctrls.Button {
        anchors.fill: parent
        inset: 0
        checked: Services.ScreenCapture.recording
        icon.name: "media-record-symbolic"
        icon.color: "red"
        radius: widgetData.radius
        onClicked: () => Services.ScreenCapture.toggleRecording()
    }
}
