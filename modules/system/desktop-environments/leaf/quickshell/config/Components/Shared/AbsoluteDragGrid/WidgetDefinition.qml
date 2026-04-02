import QtQml

QtObject {
    required property string id // ID which is unique among all other WidgetDefinitions
    required property string name // Human readable name
    required property int columnSpan // The number of columns this widget spans
    required property int rowSpan // The number of rows this widget spans
}
