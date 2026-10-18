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
import qs.Services as Services

// TODO: Maybe rewrite this without using the button control since we want some more special animation behavior
Ctrls.Button {
    id: root
    required property var ws // This: https://github.com/imiric/qml-niri#workspacemodel-roles
    required property bool isLast

    padding: inset
    inset: 4
    //topInset: root.ws.isActive ? 6 : 8
    //bottomInset: root.ws.isActive ? 6 : 8
    Behavior on topInset {
        PropertyAnimation {
            duration: 150
        }
    }
    Behavior on bottomInset {
        PropertyAnimation {
            duration: 150
        }
    }

    onHoveredChanged: {
        if (root.hovered) {
            Root.State.hoveredWorkspaceButton = root;
            Root.State.hoveredWorkspace = ws;
        }
    }
    onClicked: {
        Services.Niri.focusWorkspaceById(ws.id);
    }

    background: Rectangle {
        radius: height / 2
        //implicitWidth: root.contentItem.implicitWidth < 52 ? 52 : root.contentItem.implicitWidth + 16
        implicitWidth: root.contentItem.implicitWidth + root.padding
        implicitHeight: root.contentItem.implicitHeight + root.padding
        Behavior on implicitWidth {
            PropertyAnimation {
                duration: 150
            }
        }
        color: root.hovered || root.ws.isActive ? Root.State.colors.primary_container : !root.isLast ? Root.State.colors.surface_container : "transparent"
    }

    contentItem: RowLayout {
        spacing: 0 // App list
        Text {
            id: displayName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            visible: root.ws.name != "" || root.isLast
            text: !root.isLast ? root.ws.name : "+"
            font.pointSize: 8
            color: root.hovered || root.ws.isActive ? Root.State.colors.on_primary_container : !root.isLast ? Root.State.colors.on_primary_container : Root.State.colors.on_surface
            padding: 8
        }
        Loader {
            visible: active // Size stays same after item is unloaded.  Hide to not render in this case.
            active: true//root.ws.isActive || root.hovered
            property Component appListComp: RowLayout {
                spacing: 0
                Repeater {
                    id: repeater
                    model: SortFilterProxyModel {
                        model: Services.Niri.windows
                        filters: [
                            FunctionFilter {
                                function filter(w: RoleData): bool {
                                    return w.workspaceId == root.ws.id;
                                }
                            }
                        ]
                    }
                    //model: ToplevelManager.toplevels // Currently doesn't have a way to map to windowsets
                    delegate: Ctrls.Button {
                        id: toplevelButton
                        // WindowModel roles which are the properties of the modelData https://github.com/imiric/qml-niri#windowmodel-roles
                        required property var modelData
                        isMultiColorIcon: true

                        // Ensure static aspect ratio and limit size to available height
                        icon.width: icon.height
                        icon.height: background.implicitHeight - inset

                        //implicitHeight: root.background.height
                        inset: 0// root.inset + 2
                        padding: 0
                        icon.source: modelData.iconPath ?? Quickshell.iconPath(modelData.appId)
                        onClicked: () => Services.Niri.focusWindow(modelData.id)
                    }
                }
            }
            sourceComponent: appListComp
        }
    }
    component RoleData: QtObject {
        property string workspaceId
    }
}
