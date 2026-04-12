
// TODO: Move to seperate component
/*
Rectangle {
    id: editPanel
    visible: root.allowEditToggle
    property int expandedHeight: 300
    Layout.preferredHeight: root.editable ? expandedHeight : 0
    Behavior on Layout.preferredHeight { PropertyAnimation { duration: 500; easing.type: Easing.Linear} }
    Layout.fillWidth: true
    color: "red"
    clip: true
    Shared.ScrollableList {
        anchors.fill: parent
        model: root.availableWidgetDefinitions
        delegate: PanelTile {
            required property WidgetDefinition modelData
            widgetDefinition: modelData
            widgetInstance: root.logic.generateWidgetInstance(root.model, 0, 0)
            editable: true
            unitSize: root.unitSize
        }
    }
}
*/
