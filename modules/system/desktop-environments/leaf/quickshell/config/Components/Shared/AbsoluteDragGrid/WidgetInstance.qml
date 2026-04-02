import QtQml

QtObject {
    required property string uid // A unique across all WidgetInstances
    required property string widgetDefinitionId // The ID of the WidgetDefinition this instance corresponds to
    required property int xPosition // The x position this WidgetInstance is located at
    required property int yPosition // The y position this widgetInstance is located at
    required property var state // An object representing any state of the widget.  Null if widget has no state.
}
