pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

// TODO: Maybe rewrite this without using the button control since we want some more special animation behavior
Ctrls.Button {
    id: root
    required property Windowset ws
    required property bool isLast

    leftInset: 2
    rightInset: 2
    topInset: root.ws.active ? 6 : 8
    bottomInset: root.ws.active ? 6 : 8
    Behavior on topInset { PropertyAnimation {duration: 150} }
    Behavior on bottomInset { PropertyAnimation {duration: 150} }
    padding: 0

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
        implicitWidth: root.ws.active ? 52 : 40
        Behavior on implicitWidth { PropertyAnimation {duration: 150} }
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
            text: !root.isLast ? root.ws.name : "+"
            font.pointSize: 8
            color: root.hovered || root.ws.active
                ? Root.State.colors.on_primary
                : !root.isLast 
                    ? Root.State.colors.on_primary_container
                    : Root.State.colors.on_surface
            }
    }
}
