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
// TODO: Add param to set the parent window so that if it has a focus grab we can deactive and active it as needed
PopupWindow {
    id: root

    required property Item content
    property bool parentWindowHasGrab: true // Whether the parent window of this has a HyprlandFocusGrab active
                                             // Used to disable and re-enable the parents grab while handling the 
                                             // one for this popup
    property HyprlandFocusGrab previousGrab: null
    implicitWidth: popupArea.width
    implicitHeight: popupArea.height
    color: "transparent"

    function closeWindow() {
        console.log('popup close window')
        root.visible = false
    }

    visible: false
    onVisibleChanged: {
        if (visible) {
            root.previousGrab = Root.State.activeGrab // Store previous grab in this component
            Root.State.activeGrab = grab
            console.log(`PREVIOUS GRAB SET TO: ${root.previousGrabChanged}`)
            console.log(`ACTIVE GRAB SET TO: ${Root.State.activeGrab}`) 
        }
        else {
            Root.State.activeGrab = root.previousGrab
            Root.State.activeGrab.active = true
        }
    }

    //////////////////////////////////////////////////////////////// 
    // Focus Grab
    //////////////////////////////////////////////////////////////// 
    // Note: It appears that setting a HyprlandFocusGrab to active will trigger
    // the cleared signal on any other HyprlandFocusGrab
    // Yep, this is the expected behavior, only one grab can be active at a time
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 10
        repeat: false
        onTriggered: {
            // Only active grab if window is visible
            if (root.visible) {
                console.log('POPUP: grab triggered for ' + root.visible)
                //Root.State.panelGrab.active = false // Need to set the parent window grab to false or else it's cleared will get triggered somehow
                root.previousGrab.active = false
                grab.active = true
            }
            // Other wise the window was hidden, deactivate the grab
            else {
                grab.active = false
                // TODO: this is temp fix for non nested popup
                //Root.State.panelGrab.active = false // Need to set the parent window grab to false or else it's cleared will get triggered somehow
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
        active: false
        windows: [root]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log(`POPUP: clearing grab for ${grab}`)
            root.closeWindow() // Assumes this method exists
            // Re-enable the parent grab if needed
            if (root.parentWindowHasGrab) {
                //Root.State.panelGrab.active = true
                root.previousGrab.active = true
            }
        }
    }

    WrapperMouseArea {
        id: popupArea
        enabled: true
        focus: true
        hoverEnabled: true
        WrapperRectangle {
            id: box
            //color: palette.window
            color: "#aa111111"
            radius: Root.State.rounding
            margin: 4
            children: [ root.content ]
        }
    }
}
