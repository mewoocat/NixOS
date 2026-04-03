import QtQuick
import qs as Root

Item {
    required property string uid // A ID which is unique among all other WidgetDefinitions
    required property string name // Human readable name
    required property int xSize // The number of cells this widget spans on the x-axis
    required property int ySize // The number of cells this widget spans on the y-axis
    required property var defaultState // An object representing the default state of the widget.  Null if widget has no state.
    required property Component component // The actual content to render

    property int unitSize: 64
    property int padding: 0
    property int availableWidth: unitSize * xSize
    property int availableHeight: unitSize * ySize
}
