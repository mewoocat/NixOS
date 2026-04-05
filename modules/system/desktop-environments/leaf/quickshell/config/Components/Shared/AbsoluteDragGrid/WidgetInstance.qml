import QtQml

QtObject {
    required property string uid // A unique across all WidgetInstances
    required property string widgetDefinitionId // The ID of the WidgetDefinition this instance corresponds to
    required property int xPosition // The x position this WidgetInstance is located at
    required property int yPosition // The y position this widgetInstance is located at
    required property int xSize // The number of cells this widget spans on the x-axis
    required property int ySize // The number of cells this widget spans on the y-axis
    required property var state // An object representing any state of the widget.  Null if widget has no state.

    // Optional

    // A reference to the WidgetDefinition (will use this if not null instead of searching available definitions).
    // Useful for defining the widget inline for non editable grids.  Also not serialized.
    property WidgetDefinition widgetDefinition: null
}
