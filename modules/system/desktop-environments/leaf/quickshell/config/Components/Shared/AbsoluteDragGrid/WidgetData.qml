import QtQml

// Only some of the properties here are serialized to json
QtObject {
    // Definition properties
    property string uid // A unique ID across all WidgetData ... TODO: Remove?
    required property string name // A human readable name for the widget
    required property int xSize // The number of cells this widget spans on the x-axis
    required property int ySize // The number of cells this widget spans on the y-axis
    property var defaultState: null // An object representing the default state of the widget. Null if widget has no state.

    // State properties
    property int xPosition: 0 // The x position this WidgetInstance is located at
    property int yPosition: 0 // The y position this widgetInstance is located at
    property var state: defaultState // An object representing any state of the widget. Null if widget has no state.

    // Item properties
    required property Component component // The actual content to render 
    property int padding: 8
    property int radius: 8
    property bool showBackground: true
}
