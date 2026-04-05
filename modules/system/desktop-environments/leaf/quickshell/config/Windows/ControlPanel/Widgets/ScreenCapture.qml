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

AbsGrid.WidgetDefinition { 
    id: root
    uid: "screen-capture-1x1"
    name: "Screen Capture (1x1)"
    xSize: 1
    ySize: 1
    defaultState: null
    onClicked: () => Services.ScreenCapture.toggleRecording()
    active: Services.ScreenCapture.recording
    component: IconImage {
        visible: root.active || root.hovered
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
}
