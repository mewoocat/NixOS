pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetDefinition { 
    id: root
    uid: "screen-capture-1x1"
    name: "Screen Capture (1x1)"
    xSize: 2
    ySize: 2
    defaultState: null
    //onClicked: Root.State.controlPanelPage = 2
    component: IconImage {
        anchors.centerIn: parent
        implicitSize: 32
        source: Quickshell.iconPath("media-record-symbolic")
        // Recolor
        layer.enabled: false
        layer.effect: MultiEffect {
            colorization: 1 // Full re-color
            colorizationColor: "red"
        }
    }
    onClicked: () => Services.ScreenCapture.toggleRecording()
    isActive: Services.ScreenCapture.recording
}
