pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls

Ctrls.Button {
    id: root
    required property int wsId

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

    onHoveredChanged: {
        if (root.hovered) {
            Root.State.currentHoveredWorkspace = root
            Root.State.hoveredWorkspace = wsId
        }
    }
    onClicked: {
        Hyprland.dispatch(`workspace ${root.wsId}`)
    }

    property HyprlandWorkspace wsObj: Hyprland.workspaces.values.find(ws => ws.id === wsId) ?? null
    property string wsName: Root.State.config.workspaces.wsMap[`ws${wsId}`].name
    // Either focused, active, inactive, or empty
    property string wsState: {
        if (wsObj === null) {
            return "empty"
        }
        if (wsObj.focused) {
            return "focused"
        }
        if (wsObj.active) {
            return "active"
        }
        if (wsObj.toplevels.values.length < 1) {
            return "empty"
        }
        if (wsObj.toplevels.values.length > 0) {
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
                    return root.largeSize
                case "active":
                case "inactive":
                    return root.dotSize
                case "empty":
                    return root.smallDotSize
                default:
                    console.error("Invalid wsState")
                    return root.mediumSpace
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

    contentItem: Rectangle {
        color: "transparent"
        Text {
            anchors.centerIn: parent
            id: displayName
            opacity: root.wsState == "empty" ? 0.5 : 1
            text: {
                switch(root.wsState) {
                    case "focused":
                    case "active":
                        return root.wsName !== "" ? root.wsName : root.wsId
                    case "empty":
                    case "inactive":
                        return root.wsId
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

}
