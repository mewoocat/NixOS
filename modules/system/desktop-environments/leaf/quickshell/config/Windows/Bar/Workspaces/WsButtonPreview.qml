pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell.Widgets
import Quickshell
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs.Services as Services
import Niri

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

    topPadding: topInset
    bottomPadding: bottomInset

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

    contentItem: Rectangle {
        color: "#ff00ff00"
        Repeater {
            model: ScriptModel {
                values: [... Services.Niri.windows]//.filter(w => w.id == root.ws.id)
            }
            //model: Services.Niri.windows
            Component.onCompleted: console.log(`niri windows: ${model.values}`)
            Rectangle {
                color: "red"
                width: 10
                height: 10
            }
        }
    }
}
