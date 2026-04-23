pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Services as Services
import qs as Root

// TODO: wrap in loader so that popup is only loaded when it needs to be seen
//
// WARNING: If blur is disabled in hyprland but the layer still has it enabled for popups, then some square corners
// will show up around these popup windows.  Also disabling the blur for the layer fixes this.  But disabling the 
// popup blur globally won't apply to this layer.
//
// NOTE: Shadows are implemented here since they are not supported in niri/hyprland for layer popups
//
// A basic window to appear over PanelWindows at a certian position
PopupWindow {
    id: root

    required property Item content
    property bool grabEnabled: true
    property color bgColor: Root.State.colors.surface_container
    property int shadowSize: 8
    implicitWidth: mouseArea.width
    implicitHeight: mouseArea.height
    //Behavior on implicitHeight { PropertyAnimation { duration: 100 } }
    //Behavior on anchor.item { PropertyAnimation { duration: 1000 } }
    color: "transparent"
    grabFocus: true
    anchor {
        /*
        // The rect[x,y] seems to always be relative to the item's (0,0)
        rect.x: -root.shadowSize
        rect.y: 0//root.anchor.item.height
        */
    }
    // Specify the region of the layer to have blur applied to it
    BackgroundEffect.blurRegion: Region {
        item: background
        radius: background.radius
    }

    // IMPORTANT: Make sure to call this method before the PopupWindow is destoryed, or else a 
    // crash may occur.
    function closeWindow() {
        // Pretty sure hiding this popup will trigger the HyplandFocusGrab cleared signal.
        // Because it would be the only window in the HyprlandFocusGrab window list and 
        // hiding all in the list fires the signal.
        root.visible = false
    }

    onVisibleChanged: {
        if (visible && grabEnabled) {
            Services.Hyprland.addGrabWindow(root)
        }
    }

    // MouseArea for detecting if mouse is contained within the popup
    MouseArea {
        id: mouseArea
        width: shadowBox.width
        height: shadowBox.height

        // Make the popup large enough to display a shadow under it's background
        Item {
            id: shadowBox
            width: background.width + root.shadowSize * 2
            height: background.height + root.shadowSize * 2

            RectangularShadow {
                id: shadow
                width: background.width - spread * 2
                height: background.height - spread * 2
                radius: background.radius
                x: background.x + -root.shadowSize + spread
                y: background.y + root.shadowSize + spread
                blur: 4
                spread: 4
                opacity: 0.35
                color: Root.State.colors.shadow
            }

            WrapperRectangle {
                id: background
                x: root.shadowSize
                y: root.shadowSize
                color: root.bgColor
                radius: Root.State.rounding
                border.color: Root.State.colors.surface_bright
                border.width: 1
                // Needed to move the first item down by 1 pixel since it seems theres a bug where the
                // topleft most pixel on Qs:PopupWindow has focus went the popup is first opened but the
                // mouse hasn't moved yet.
                //margin: 1
                child: root.content
                margin: 4
            }
        }
    }
}
