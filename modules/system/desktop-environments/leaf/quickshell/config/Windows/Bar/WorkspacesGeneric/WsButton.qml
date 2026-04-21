pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls

Ctrls.Button {
    id: root
    required property Windowset ws

    property int smallSize: 10
    property int mediumSize: 16
    property int largeSize: 36

    implicitHeight: 40 // Default
    property int dotSize: 22
    property int smallDotSize: 18

    topInset: 10
    bottomInset: 10
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
        //Hyprland.dispatch(`workspace ${root.ws.id}`)
    }

    background: Rectangle {
        radius: height / 2
        implicitWidth: 40
        Behavior on implicitWidth { PropertyAnimation {duration: 100} }
        Behavior on implicitHeight { PropertyAnimation {duration: 20} }
        color: root.hovered || root.ws.active
            ? Root.State.colors.primary
            : Root.State.colors.primary_container
    }

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: 6
        rightPadding: 6
        id: displayName
        text: root.ws.id + " | " + root.ws.name
        font.pointSize: 8
        color: root.hovered || root.ws.active
            ? Root.State.colors.on_primary
            : Root.State.colors.on_primary_container
    }
}
