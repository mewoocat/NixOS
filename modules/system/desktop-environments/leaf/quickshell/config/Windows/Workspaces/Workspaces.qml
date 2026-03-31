pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared 

Shared.PopupWindow {
    id: root
    bgColor: Root.State.colors.surface
    property var currentHoveredWorkspace: Root.State.currentHoveredWorkspace
    onCurrentHoveredWorkspaceChanged: () => {
        // The Popup.anchor.item property seems to have some sort of issue with binding, so manually
        // setting the item when it changes and updating the anchor seems to be needed.
        root.anchor.item = currentHoveredWorkspace
        root.anchor.updateAnchor()
    }
    visible: Root.State.isWorkspacePopupVisible
    grabEnabled: false // Disable the HyprlandFocusGrab
    anchor {
        // Give a slight negative margin to move the popup to the left so that there's hopefully no posibility that the mouse can exit the 
        // workspace button while only clipping the edge of the popup so that only the entered signal is fired.
        margins.left: -1
        item: root.currentHoveredWorkspace // WARNING: don't set this to null once visible, will cause crash
        edges: Edges.Bottom | Edges.Left
        gravity: Edges.Bottom | Edges.Right
    }
    content: MouseArea {
        hoverEnabled: true
        // Add a area around the content to allow for mouse hover checking.  Doesn't seem that nested MouseAreas can
        // propagate hover events.
        implicitWidth: workspace.width + 20
        implicitHeight: workspace.height + 20
        onEntered: () => Root.State.isWorkspacePopupHovered = true
        onExited: () => Root.State.isWorkspacePopupHovered = false
        Workspace {
            id: workspace
            anchors.centerIn: parent
            wsId: Root.State.hoveredWorkspace
            widgetWidth: 800
        }
    }
}

