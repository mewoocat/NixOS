pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Widgets
import qs as Root

MouseArea {
    id: root

    required property WidgetInstance widgetInstance
    required property WidgetDefinition widgetDefinition
    required property int unitSize

    enabled: widgetDefinition.isButton
    hoverEnabled: enabled
    property bool interactable: enabled

    onClicked: widgetDefinition.clicked()

    property bool editable: false
    property int padding: 8

    signal tileSelected(item: PanelTile)
    signal positionUpdateRequested(item: PanelTile)
    signal widgetPositionChanged(item: PanelTile)

    property int initialX: 0
    property int initialY: 0
    function resetPosition() {
        x = initialX
        y = initialY
    }

    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size is forced to the BoundComponent's size
    implicitWidth: widgetDefinition.xSize * unitSize
    implicitHeight: widgetDefinition.ySize * unitSize
    x: widgetInstance?.xPosition * unitSize
    y: widgetInstance?.yPosition * unitSize
    Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    

    Rectangle {
        x: root.padding
        y: root.padding
        width: parent.width - root.padding * 2
        height: parent.height - root.padding * 2
        color: root.interactable && root.containsMouse ? Root.State.colors.primary : Root.State.colors.surface_container
        radius: Root.State.innerRounding
        Loader {
            anchors.fill: parent
            sourceComponent: root.widgetDefinition.component
        }
    }
    // Note that this appears over the content when active
    MouseArea {
        visible: root.editable
        anchors.fill: parent
        onXChanged: root.widgetPositionChanged(root)
        onYChanged: root.widgetPositionChanged(root)

        Behavior on x { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        Behavior on y { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        
        drag.target: root
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
        onPressed: {
            // Store original position
            root.initialX = root.x
            root.initialY = root.y
            root.tileSelected(root) // emit signal
        }
        onReleased: {
            root.positionUpdateRequested(root)
        }
    }
}
