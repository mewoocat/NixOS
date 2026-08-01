import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls

PanelWindow {
    width: bg.width
    height: bg.height
    anchors.bottom: true
    margins.bottom: 100
    color: "transparent"
    visible: Services.OSD.visible
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: 'quickshell-panel-' + 'osd'
    Rectangle {
        id: bg
        property int margins: 8
        width: loader.width + loader.margins * 2
        height: loader.height + loader.margins * 2
        color: "#bb212121"
        radius: Root.State.rounding
        Loader {
            id: loader
            x: margins
            y: margins
            property int margins: 8
            property Component volumeDelegate: Volume {}
            property Component brightnessDelegate: Brightness {}
            sourceComponent: switch(Services.OSD.mode) {
                case "volume":
                    return volumeDelegate
                case "brightness":
                    return brightnessDelegate
                default:
                    return null
            }
        }
    }
}
