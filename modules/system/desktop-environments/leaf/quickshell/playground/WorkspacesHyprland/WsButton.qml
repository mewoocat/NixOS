pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls

Ctrls.Button {
    id: root
    required property HyprlandWorkspace ws

    property int smallSize: 10
    property int mediumSize: 16
    property int largeSize: 36

    implicitHeight: 40 // Default
    property int dotSize: 22
    property int smallDotSize: 18

    property int verticalInset: wsState != "empty" ? height - dotSize : height - smallDotSize
    topInset: verticalInset / 2
    bottomInset: verticalInset / 2
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
        Hyprland.dispatch(`workspace ${root.ws.id}`)
    }

    //property string wsName: Root.State.config.workspaces.wsMap[`ws${wsId}`].name
    // Either focused, active, inactive, or empty
    property string wsState: {
        if (ws.focused) {
            return "focused"
        }
        if (ws.active) {
            return "active"
        }
        if (ws.toplevels.values.length < 1) {
            return "empty"
        }
        if (ws.toplevels.values.length > 0) {
            return "inactive"
        }
        console.error(`something bad happened`)
    }

    background: Rectangle {
        radius: height / 2
        implicitWidth: {
            switch(root.wsState) {
                case "focused":
                    /*
                    if (displayName.implicitWidth > root.largeSize ) {
                        return displayName.implicitWidth
                    }
                    */
                    //return root.largeSize
                    return Math.max(root.contentItem.implicitWidth, root.dotSize)
                case "active":
                case "inactive":
                    return root.dotSize
                case "empty":
                    return root.smallDotSize
                default:
                    console.error("Invalid wsState")
                    return 0
            }
        }
        Behavior on implicitWidth { PropertyAnimation {duration: 100} }
        Behavior on implicitHeight { PropertyAnimation {duration: 20} }
        color: {
            if (root.hovered) {
                return Root.State.colors.primary
            }
            switch(root.wsState) {
                case "focused":
                case "active":
                    return Root.State.colors.primary
                case "inactive":
                    return Root.State.colors.primary_container
                case "empty":
                    return Root.State.colors.surface_container
                default:
                    console.error("invalid wsState")
            }
        }
    }

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: 6
        rightPadding: 6
        id: displayName
        opacity: root.wsState == "empty" ? 0.5 : 1
        text: {
            switch(root.wsState) {
                case "focused":
                case "active":
                    return root.ws.name
                case "empty":
                case "inactive":
                    return root.ws.id
                default:
                    console.error("Invalid wsState")
            }
        }
        font.pointSize: 8

        color: {
            if (root.hovered) {
                return Root.State.colors.on_primary
            }
            switch(root.wsState) {
                case "focused":
                case "active":
                    return Root.State.colors.on_primary
                case "inactive":
                    return Root.State.colors.on_primary_container
                case "empty":
                    return Root.State.colors.on_surface_variant
                default:
                    console.error("invalid wsState")
                    return "red"
            }
        }
    }
}
