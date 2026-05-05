import QtQml
import QtQuick

// NOTE: Only some of the properties here are serialized to json
// NOTE: Some of the required properties are injected when the component is created, not when it's defined (i.e. panelGrid)
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
    required property int padding
    required property int radius
    property bool showBackground: true
    required property Item panelGrid // This is useful when a widget component needs to know the geometry of it's PanelGrid
}
