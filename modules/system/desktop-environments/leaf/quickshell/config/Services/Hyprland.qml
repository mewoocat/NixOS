pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs as Root

Singleton {
    id: root

    property int numWorkspaces: 10
    property var workspaces: Hyprland.workspaces
    property HyprlandWorkspace activeWorkspace: Hyprland.focusedMonitor?.activeWorkspace ?? null

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            // TODO: Optimize pls
            Hyprland.refreshWorkspaces()
            Hyprland.refreshMonitors()
            //Hyprland.refreshToplevels() // Clients // CAUSES CRASH IF SPAMMED
            

            switch(event.name) {
                // If monitor add/remove event occured
                case "monitoradded":
                case "monitoraddedv2":
                case "monitorremoved":
                case "monitorremovedv2":
                    // Need to move workspaces to their assigned monitors given the new monitor configuration
                case "workspacev2":

            }
        }
    }


    //////////////////////////////////////////////////////////////// 
    // Focus Grab
    //////////////////////////////////////////////////////////////// 
    // Close on click away:
    // Create a timer that sets the grab active state after a delay
    // Used to workaround a race condition with HyprlandFocusGrab where the onVisibleChanged
    // signal for the window occurs before the window is actually created
    // This would cause the grab to not find the window

    property list<QtObject> ignoredGrabWindows: []
    onIgnoredGrabWindowsChanged: {
        //console.log('ignore list changed')
        //delay.start()
    }
    property QtObject activeGrabWindow: null
    //onActiveGrabWindowChanged: console.debug(`activeGrabWindow: ${activeGrabWindow}`)

    // Focus grab stack
    // Holds the previous grab window.  Used to reset the HyprlandFocusGrab
    // back to the previous grabbed window when a nested grab focus occurs
    property list<var> focusGrabStack: []
    function addGrabWindow(window: QtObject/*, (ignoredWindows: list<QtObject>*/) { 
        grab.active = false
        // If a window is already grabbed, push it to the stack before overwriting it
        if (root.activeGrabWindow !== null) { 
            root.focusGrabStack.push(root.activeGrabWindow)
        }
        root.activeGrabWindow = window
        root.ignoredGrabWindows = [window]
        //root.ignoredGrabWindows = [...ignoredWindows] // For some reason we need to copy the array in

        delay.start() // Set grab active status
    }
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 100
        repeat: false
        onTriggered: () => grab.active = true
    }

    // A single focus grab instance which is shared
    HyprlandFocusGrab {
        id: grab
        active: false
        //onActiveChanged: console.log(`grab.active = ${active}`)
        windows: root.ignoredGrabWindows
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            //console.debug(`clearing grab for ${root.activeGrabWindow}`)
            root.activeGrabWindow.closeWindow() // Assumes this method exists
            grab.active = false

            // Revert to the previous grab context
            if (root.focusGrabStack.length > 0) {
                //console.debug(`focus grab stack ${root.focusGrabStack}`)
                const previousGrabWindow = root.focusGrabStack.pop()
                //console.debug(`reverting focus grab to ${previousGrabWindow}`)
                root.activeGrabWindow = previousGrabWindow
                root.ignoredGrabWindows = [previousGrabWindow]
                delay.start()
            }
            // Otherwise there should be no active grab
            else {
                root.activeGrabWindow = null
            }
        }
    }
}
