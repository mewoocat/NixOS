import QtQml

QtObject {
    required property string id // ID which is unique among all other WidgetDefinitions
    required property string name // Human readable name
    required property int xSize // The number of cells this widget spans on the x-axis
    required property int ySize // The number of cells this widget spans on the y-axis
    required property var defaultState // An object representing the default state of the widget.  Null if widget has no state.
    required property var component // The actual content to render
}
