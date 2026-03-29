import QtQuick
import QtQuick.Layouts
import qs as Root

// Horizontal line
// Designed to be used in a ColumnLayout
Rectangle {
    Layout.fillWidth: true
    radius: 20
    implicitHeight: 1
    color: Root.State.colors.on_surface_variant
    opacity: 0.6
}
