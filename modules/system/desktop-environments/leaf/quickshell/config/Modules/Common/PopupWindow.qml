import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../../Services" as Services

// TODO: wrap in loader so that popup is only loaded when it needs to be seen
// TODO: Fix issue with moving mouse too slow from button to popupwindow where the popup window 
//       doesn't receive focus right away and thus gets hidden before it can be hovered
PopupWindow {
    id: root

    anchor {
        //window: root.window
        //item: root.item
        //edges: Edges.Bottom | Edges.Right
        //gravity: Edges.Top | Edges.Right
        /*
        rect.y: 1 // Push the window down a pixel to not have it skip between hoving
                  // the button and popup
        */
    }

    function closeWindow() {
        console.log('popup close window')
        root.visible = false
    }

    //visible: power.containsMouse || popupArea.containsMouse // For hovering to open
    visible: false
    //TODO: causes crash
    onVisibleChanged: {
        console.log('Common.PopupWindow on vis change')
        if (root.visible) {
            Services.Hyprland.addGrabWindow(root, [root])
        }

        /*
        // Hovering to open logic
        // If just became visible
        if (popup.visible) {
            Root.State.focusGrabIgnore.push(popup) // Add the popup to the ignore list, so that it can receive mouse focus
        }
        // Else just hidden
        /*
        else {
            // Remove self from the ignore list
            const popupIndex = Root.State.focusGrabIgnore.indexOf(popup)
            Root.State.focusGrabIgnore.splice(popupIndex, 1)
        }
        */
    }
    implicitWidth: popupArea.width
    implicitHeight: popupArea.height
    color: "transparent"
    WrapperMouseArea {
        id: popupArea
        enabled: true
        focus: true
        hoverEnabled: true
        onEntered: { console.log("entered") }
        onExited: { console.log("exited") }
        WrapperRectangle {
            id: box
            //color: palette.window
            color: "#aa111111"
            radius: 8
            margin: 8
            ColumnLayout {
                PopupMenuItem { text: "Shutdown"; action: ()=>{}; iconName: "system-shutdown-symbolic"}
                PopupMenuItem { text: "Hibernate"; action: ()=>{}; iconName: "system-shutdown-symbolic"}
                PopupMenuItem { text: "Restart"; action: ()=>{}; iconName: "system-restart-symbolic"}
                PopupMenuItem { text: "Sleep"; action: ()=>{}; iconName: "system-suspend-symbolic"}
            }
        }
    }
}
