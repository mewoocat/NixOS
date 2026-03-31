import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.Services as Services
import qs as Root

// TODO: wrap in loader so that popup is only loaded when it needs to be seen
// TODO: Fix issue with moving mouse too slow from button to popupwindow where the popup window 
//       doesn't receive focus right away and thus gets hidden before it can be hovered
// TODO: Add param to set the parent window so that if it has a focus grab we can deactive and active it as needed
//
// WARNING: If blur is disabled in hyprland but the layer still has it enabled for popups, then some square corners
// will show up around these popup windows.  Also disabling the blur for the layer fixes this.  But disabling the 
// popup blur globally won't apply to this layer.
//
// A basic window to appear over PanelWindows at a certian position
PopupWindow {
    id: root

    required property Item content
    property bool grabEnabled: true
    property color bgColor: Root.State.colors.surface_container
    implicitWidth: popupArea.width
    implicitHeight: 1//popupArea.height
    //Behavior on implicitHeight { PropertyAnimation { duration: 100 } }
    //Behavior on anchor.item { PropertyAnimation { duration: 1000 } }
    color: "transparent"
    //surfaceFormat.opaque: true

    // IMPORTANT: Make sure to call this method before the PopupWindow is destoryed, or else a 
    // crash may occur.
    function closeWindow() {
        console.log('popup close window')
        // Pretty sure hiding this popup will trigger the HyplandFocusGrab cleared signal.
        // Because it would be the only window in the HyprlandFocusGrab window list and 
        // hiding all in the list fires the signal.
        root.visible = false
    }

    onVisibleChanged: {
        if (visible) {
            root.implicitHeight = popupArea.height
        }
        else {
            root.implicitHeight = 1
        }
        if (visible && grabEnabled) {
            console.log(`popup window vis changed to ${root.visible}`)
            Services.Hyprland.addGrabWindow(root)
        }
    }

    WrapperRectangle {
        id: popupArea
        color: root.bgColor
        radius: Root.State.rounding
        // Needed to move the first item down by 1 pixel since it seems theres a bug where the
        // topleft most pixel on Qs:PopupWindow has focus went the popup is first opened but the
        // mouse hasn't moved yet.
        margin: 1
        children: [ root.content ]
    }
}
