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
        id: root
        anchors.fill: parent
        inset: 0
        backgroundColor: root.hovered ? Root.State.colors.primary : Root.State.colors.surface_container
        icon.name: "media-record-symbolic"
        icon.color: "red"
        radius: widgetData.radius
        onClicked: () => Services.ScreenCapture.toggleRecording()
    }
}
