pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared 

Shared.PopupWindow {
    id: root
    bgColor: "transparent"//Root.State.colors.surface
    property Item hoveredWsBtn: Root.State.hoveredWorkspaceButton
    onHoveredWsBtnChanged: () => {
        // The Popup.anchor.item property seems to have some sort of issue with binding, so manually
        // setting the item when it changes and updating the anchor seems to be needed.
        root.anchor.item = hoveredWsBtn
        root.anchor.updateAnchor()
    }
    //Behavior on anchor.rect.x { NumberAnimation { duration: 200; easing.type: Easing.Linear} }
    visible: Root.State.isWorkspacePopupVisible
    grabEnabled: false // Disable the HyprlandFocusGrab
    anchor {
        // Give a slight negative margin to move the popup to the left so that there's hopefully no posibility that the mouse can exit the 
        // workspace button while only clipping the edge of the popup so that only the entered signal is fired.
        margins.left: -1
        item: Root.State.hoveredWorkspaceButton // WARNING: don't set this to null once visible, will cause crash
        edges: Edges.Bottom | Edges.Left
        //edges: Edges.Top | Edges.Left
        gravity: Edges.Bottom | Edges.Right
    }
    content: WrapperMouseArea {
        hoverEnabled: true
        onEntered: () => Root.State.isWorkspacePopupHovered = true
        onExited: () => Root.State.isWorkspacePopupHovered = false
        // Add a area to top allow for mouse hover checking.  Doesn't seem that nested MouseAreas can
        // propagate hover events.
        topMargin: 8
        WrapperRectangle {
            color: Root.State.colors.surface
            radius: Root.State.rounding
            Loader {
                active: Root.State.hoveredWorkspace != null
                property Component workspace: Workspace {
                    anchors.centerIn: parent
                    ws: Root.State.hoveredWorkspace
                    widgetWidth: 400
                }
                sourceComponent: workspace
            }
        }
    }
}

