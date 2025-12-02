import QtQuick

// Represents the properties needed to construct an instance of a widget
Item {
    required property string widgetId
    required property int xSpan
    required property int ySpan
    required property Component content
}
