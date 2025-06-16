pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../" as Root

Singleton {
    id: root

    // This no work
    //property ObjectModel<HyprlandMonitor> monitors: Hyprland.monitors
    property list<HyprlandMonitor> monitorsObjs: Hyprland.monitors.values

    function enable(){
        console.log("Enabling Hyprland Service")
    }
    Component.onCompleted: {
        //console.log(monitorsObjs)
    }
    property int activeWsId: {
        // Can be null, default to 0
        if (Hyprland.focusedMonitor === null) {
            return 0
        }
        return Hyprland.focusedMonitor.activeWorkspace.id
    }
    property var workspaceMap: {
        let map = {}
        Hyprland.workspaces.values.forEach(w => {
            map[w.id] = w
            //console.log("ws: " + map[w.id])
        })
        return map
    }

    // Map of workspace id's to array of client objects
    property var clientMap: {
        return {}
    }
    // TODO: Rewrite using a socket
    Process {
        id: clientProc
        command: ["sh", "-c", "hyprctl clients -j | jq -c"]
        running: true
        stdout: SplitParser {
            //splitMarker: "\n"
            onRead: data => {
                //console.log("data: " + data)
                const jsonData = JSON.parse(data)
                //console.log("jsonData: " + JSON.stringify(jsonData))
                let map = {}
                for (const client of jsonData) {
                    const id = client.workspace.id
                    if (map[id] === undefined) {
                        map[id] = []
                    }
                    //console.log("thing: " + client.workspace.id)
                    // Append the client into array by creating a new array of the existing items and the new client
                    map[id] = [...map[id], client]
                }
                root.clientMap = map
                //console.log("map " + JSON.stringify(clientMap[1], null, 5))
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            Hyprland.refreshWorkspaces()

            Hyprland.refreshMonitors()

            // TODO: optimize when this is ran
            clientProc.running = true
            
            //console.log(event.name + " | " + event.data) 
            if (event.name === "workspace") {
                activeWsId = event.data
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
    property QtObject activeGrabWindow: null
    property list<var> previousGrabs: [] // Holds the previous grab configurations.  Used to reset the HyprlandFocusGrab
                                         // back to the previous grabbed window when a nested grab focus occurs
    onIgnoredGrabWindowsChanged: {
        console.log('ignore list changed')
        delay.start()
    }
    function addGrabWindow(window: QtObject, ignoredWindows: list<QtObject>) { 
        // Save the previous grab context
        /*
        const previousGrab = {
            activeGrabWindow: root.activeGrabWindow,
            ignoredGrabWindows: root.ignoredGrabWindows
        }
        previousGrabs.push(previousGrab)
        */

        // Set the new grab context
        //const prevGrabState = grab.active
        grab.active = false
        root.activeGrabWindow = window
        //root.ignoredGrabWindows = [window]
        root.ignoredGrabWindows = [...ignoredWindows] // For some reason we need to copy the array in
        //grab.active = prevGrabState
    }
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 10
        repeat: false
        onTriggered: {
            console.log('grab triggered for ' + root.activeGrabWindow.visible)
            grab.active = root.activeGrabWindow.visible
        }
    }
    // Connects to the active grab window onVisibleChanged signal
    // Starts a small delay which then sets the grab active state to match the window visible state
    Connections {
        target: root.activeGrabWindow
        function onVisibleChanged() {
            //delay.start() // Set grab active status
        }
    }
    HyprlandFocusGrab {
        id: grab
        active: false
        windows: root.ignoredGrabWindows
        //windows: [ root.activeGrabWindow ]
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log('clearing grab')
            root.activeGrabWindow.closeWindow() // Assumes this method exists

            // Revert to the previous grab context
            /*
            if (root.previousGrabs.length > 0) {
                const previousGrab = root.previousGrabs.pop()
                root.activeGrabWindow = previousGrab.activeGrabWindow
                root.ignoredGrabWindows = previousGrab.ignoredGrabWindows

            }
            */
        }
    }
    /////////////////////////////////////////////////////////////////////////

}
