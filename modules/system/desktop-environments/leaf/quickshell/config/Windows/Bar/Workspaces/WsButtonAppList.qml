pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
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
        console.debug(`width: ${contentItem.width}`);
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
        // App list
        Loader {
            visible: active // Size stays same after item is unloaded.  Hide to not render in this case.
            active: root.ws.active
            property Component appListComp: RowLayout {
                Repeater {
                    id: repeater
                    // TODO: Probably need to use qml-niri plugin for now since there doesn't seem to be a good way
                    // to associate a Toplevel to a Windowset.
                    model: ToplevelManager.toplevels
                    delegate: Ctrls.Button {
                        id: toplevelButton
                        required property Toplevel modelData
                        text: modelData.appId
                        contentItem: Shared.Icon {
                            source: Quickshell.iconPath(toplevelButton.modelData.appId)
                        }
                    }
                }
            }
            sourceComponent: appListComp
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
