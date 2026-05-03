pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

Ctrls.Button {
    id: root
    required property Windowset ws
    required property bool isLast

    property int smallSize: 10
    property int mediumSize: 16
    property int largeSize: 36

    implicitHeight: 40 // Default
    property int dotSize: 22
    property int smallDotSize: 18

    topInset: 8
    bottomInset: 8
    padding: 0
    leftInset: 2
    rightInset: 2

    onHoveredChanged: {
        if (root.hovered) {
            Root.State.hoveredWorkspaceButton = root
            Root.State.hoveredWorkspace = ws
        }
    }
    onClicked: {
        ws.activate()
    }

    background: Rectangle {
        radius: height / 2
        implicitWidth: 40
        Behavior on implicitWidth { PropertyAnimation {duration: 100} }
        Behavior on implicitHeight { PropertyAnimation {duration: 20} }
        color: root.hovered || root.ws.active
            ? Root.State.colors.primary
            : !root.isLast 
                ? Root.State.colors.primary_container
                : "transparent"
    }

    contentItem: RowLayout {
        spacing: 0
        Repeater {
            // TODO
            //Shared.Icon {}
        }
        Text {
            id: displayName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            text: !isLast ? root.ws.name : "+"
            font.pointSize: 8
            color: root.hovered || root.ws.active
                ? Root.State.colors.on_primary
                : !root.isLast 
                    ? Root.State.colors.on_primary_container
                    : Root.State.colors.on_surface
            }
    }
}
