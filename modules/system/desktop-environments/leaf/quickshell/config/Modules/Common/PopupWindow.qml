import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../../Services" as Services
import "../../" as Root

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
    /*
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
        else {
            // Remove self from the ignore list
            const popupIndex = Root.State.focusGrabIgnore.indexOf(popup)
            Root.State.focusGrabIgnore.splice(popupIndex, 1)
        }
    }
    */

    //////////////////////////////////////////////////////////////// 
    // Focus Grab
    //////////////////////////////////////////////////////////////// 
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 10
        repeat: false
        onTriggered: {
            // Only active grab if window is visible
            if (root.visible) {
                console.log('POPUP: grab triggered for ' + root.visible)
                Root.State.panelGrab.active = false // Need to set the parent window grab to false or else it's cleared will get triggered somehow
                grab.active = true
            }
            // Other wise the window was hidden, deactivate the grab
            else {
                grab.active = false
            }
        }
    }
    // Connects to the active grab window onVisibleChanged signal
    // Starts a small delay which then sets the grab active state to match the window visible state
    Connections {
        target: root
        function onVisibleChanged() {
            console.log(`POPUP: window visible changed to: ${root.visible}`)
            delay.start() // Set grab active status
        }
    }
    HyprlandFocusGrab {
        id: grab
        Component.onCompleted: {
            Root.State.popupGrab = grab
        }
        active: false
        onActiveChanged: console.log(`POPUP: grab active set to: ${grab.active}`)
        windows: [root]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log('POPUP: clearing grab')
            root.closeWindow() // Assumes this method exists
            Root.State.panelGrab.active = true // Re-enable the parent grab
        }
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
