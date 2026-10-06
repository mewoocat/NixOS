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

    leftInset: 2
    rightInset: 2
    topInset: root.ws.isActive ? 6 : 8
    bottomInset: root.ws.isActive ? 6 : 8
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
        Services.Niri.focusWorkspaceById(ws.id)
    }

    background: Rectangle {
        radius: height / 2
        implicitWidth: root.ws.isActive ? 52 : 40
        Behavior on implicitWidth { PropertyAnimation {duration: 150} }
        color: root.hovered || root.ws.isActive
            ? Root.State.colors.primary
            : !root.isLast 
                ? Root.State.colors.primary_container
                : "transparent"
    } 

    contentItem: RowLayout { spacing: 0 // App list
        Loader {
            visible: active // Size stays same after item is unloaded.  Hide to not render in this case.
            active: true//root.ws.isActive || root.hovered
            property Component appListComp: RowLayout {
                Repeater {
                    id: repeater
                    // Could also probably use a SortFilterProxyModel https://doc.qt.io/qt-6/qml-qtqml-models-sortfilterproxymodel.html
                    // to filter the model rather than wrapping it in a ScriptModel
                    model: SortFilterProxyModel {
                        model: Services.Niri.windows
                        filters: [
                            FunctionFilter {
                                component RoleData: QtObject { property string workspaceId }
                                function filter(w: RoleData): bool {
                                    //console.log(`ButtonWS: ${root.ws.id}`)
                                    //console.log(`NiriWindowWS: ${JSON.stringify(w, null, 4)}`)
                                    return w.workspaceId == root.ws.id
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
                        // TODO: make size dynamic
                        icon.width: 20
                        icon.height: 20
                        icon.source: Quickshell.iconPath(toplevelButton.modelData.appId)
                        onClicked: () => Services.Niri.focusWindow(modelData.id)
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
            color: root.hovered || root.ws.isActive
                ? Root.State.colors.on_primary
                : !root.isLast 
                    ? Root.State.colors.on_primary_container
                    : Root.State.colors.on_surface
            }
    }
}
