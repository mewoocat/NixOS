import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import qs as Root

IconImage {
    id: root
    property bool recolorIcon: true
    property color color: Root.State.colors.on_surface
    implicitSize: 24
    source: ""
    // Icon recoloring
    layer.enabled: root.recolorIcon
    layer.effect: MultiEffect {
        colorization: 1
        colorizationColor: root.color
    }

    // Animate changes to the rotation property
    Behavior on rotation {
        PropertyAnimation { property: "rotation"; duration: 300 }
    }
}
