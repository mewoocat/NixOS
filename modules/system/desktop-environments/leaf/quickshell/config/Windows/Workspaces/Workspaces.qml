pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared 

Shared.PopupWindow {
    id: root
    //name: "workspaces"
    visible: Root.State.isWorkspacePopupVisible
    grabEnabled: false // Disable the HyprlandFocusGrab
    anchor {
        item: Root.State.currentHoveredWorkspace
        edges: Edges.Bottom | Edges.Left
        gravity: Edges.Bottom | Edges.Right
    }
    content: Workspace {
        wsId: Root.State.hoveredWorkspace
        widgetWidth: 400 
    }
}

