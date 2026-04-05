pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

AbsGrid.WidgetDefinition { 
    id: root
    uid: "screen-capture-1x1"
    name: "Screen Capture (1x1)"
    xSize: 1
    ySize: 1
    defaultState: null
    //active: Services.ScreenCapture.recording
    showBackground: false
    component: Ctrls.Button {
        id: btn
        anchors.fill: parent
        inset: 0
        backgroundColor: btn.hovered ? Root.State.colors.primary : Root.State.colors.surface_container
        icon.name: "media-record-symbolic"
        icon.color: "red"
        radius: root.radius
        onClicked: () => Services.ScreenCapture.toggleRecording()
    }
}
