pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs as Root

// Intended to be used as the delegate for a Leaf.ListView
// This ListItem variant doesn't support expansion
WrapperMouseArea {
    id: root

    //required property var modelData // Injected by Leaf.ListView
    required property Component delegate

    property bool showBackground: false
    property int contentMargin: 8
    property bool interacted: root.containsMouse || root.focus
    property int padding: 0

    implicitWidth: parent ? parent.width : 0 // Idk why but parent is sometimes null here.  Maybe when this delegate is removed from the view?
    hoverEnabled: true
    margin: 0

    Rectangle {
        id: background
        clip: true
        color: root.containsMouse ? Root.State.colors.surface_container_high : Root.State.colors.surface_container_highest
        radius: Root.State.rounding
        implicitWidth: parent.implicitWidth - (root.margin * 2)  // We want the width after taking into account the margins
        implicitHeight: mainBox.implicitHeight

        // Main content
        WrapperRectangle {
            id: mainBox
            implicitWidth: background.implicitWidth
            // Need to add the margin amount on each side since the mainLoader's height is shrunk by 2x the margin amount
            implicitHeight: mainLoader.implicitHeight + (root.padding * 2)
            radius: 8
            margin: root.padding
            color: "transparent"

            Loader {
                id: mainLoader
                active: true // Should always be shown
                sourceComponent: root.delegate
            }
        }
    }
}
