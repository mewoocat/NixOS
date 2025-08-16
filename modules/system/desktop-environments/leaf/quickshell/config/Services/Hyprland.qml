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
            Hyprland.refreshToplevels() // Clients

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
    onIgnoredGrabWindowsChanged: {
        //console.log('ignore list changed')
        //delay.start()
    }
    property QtObject activeGrabWindow: null

    // Focus grab stack
    property list<var> focusGrabStack: [] // Holds the previous grab window.  Used to reset the HyprlandFocusGrab
                                         // back to the previous grabbed window when a nested grab focus occurs
    function addGrabWindow(window: QtObject/*, (ignoredWindows: list<QtObject>*/) { 
        grab.active = false
        // If a window is already grabbed, push it to the stack before overwriting it
        if (root.activeGrabWindow !== null) { 
            console.log(`activeGrabWindow was not null and is ${root.activeGrabWindow}`)
            root.focusGrabStack.push(root.activeGrabWindow)
            console.log(`focus grab stack ${root.focusGrabStack}`)
        }
        root.activeGrabWindow = window
        root.ignoredGrabWindows = [window]
        //root.ignoredGrabWindows = [...ignoredWindows] // For some reason we need to copy the array in
        //grab.active = prevGrabState
        delay.start() // Set grab active status
    }
    Timer {
        id: delay
        triggeredOnStart: false
        interval: 100
        repeat: false
        onTriggered: {
            console.log('grab active for ' + root.activeGrabWindow)
            //grab.active = root.activeGrabWindow.visible
            grab.active = true
        }
    }

    // A single focus grab instance which is shared
    HyprlandFocusGrab {
        id: grab
        active: false
        onActiveChanged: console.log(`grab.active = ${active}`)
        windows: root.ignoredGrabWindows
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            console.log(`clearing grab for ${root.activeGrabWindow}`)
            root.activeGrabWindow.closeWindow() // Assumes this method exists
            grab.active = false

            // Revert to the previous grab context
            if (root.focusGrabStack.length > 0) {
                console.log(`focus grab stack ${root.focusGrabStack}`)
                const previousGrabWindow = root.focusGrabStack.pop()
                console.log(`reverting focus grab to ${previousGrabWindow}`)
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

    //////////////////////////////////////////////////////////////// 
    // Workspace Management
    //////////////////////////////////////////////////////////////// 
    
    property var selectedWorkspace: 0 // Id of selected workspace for configuring
    
    // Inline component for a json workspace
    // no work :(
    // HOWEVER, this type should be identical to the "var" json for each workspace
    /*
    component Workspace: JsonObject {
        required property int wsId
        required property bool isDefault
        property string name: ""
        property string monitor: ""
        property int gapsin: 8
        property int gapsout: 16
        property bool rounding: true
    }
    */

}
