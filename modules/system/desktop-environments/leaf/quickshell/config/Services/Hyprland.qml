pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs as Root

Singleton {
    id: root

    property int numWorkspaces: 10

    // This no work
    //property ObjectModel<HyprlandMonitor> monitors: Hyprland.monitors
    property list<HyprlandMonitor> monitorsObjs: Hyprland.monitors.values

    function enable(){
        //console.log("Enabling Hyprland Service")
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
            // TODO: Optimize pls
            Hyprland.refreshWorkspaces()
            Hyprland.refreshMonitors()
            Hyprland.refreshToplevels() // Clients

            // TODO: optimize when this is ran
            clientProc.running = true
            
            //console.log(event.name + " | " + event.data) 
            if (event.name === "workspace") {
                activeWsId = event.data
            } 

            switch(event.name) {
                // If monitor add/remove event occured
                case "monitoradded":
                case "monitoraddedv2":
                case "monitorremoved":
                case "monitorremovedv2":
                    // Need to move workspaces to their assigned monitors given the new monitor configuration

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
    
    property var selectedWorkspaceId: 1 // Id of selected workspace for configuring
    // Currently selected workspace for configuration
    property Workspace selectedWorkspace: Root.State.config.workspaces.wsMap[`ws${selectedWorkspaceId}`]

    // idea
    /*
    property var wsToMonitorMap: ({}) // Holds the current monitor assigned to each workspace
    Component.onCompleted: () => {
        const id = Monitors.generateId()
        var preset = Root.State.config.workspaces.wsConfMap[id]
        if (!preset) {
            preset = autoGeneratePreset()
        }
        wsToMonitorMap = preset
    }
    */
    //property string currentMonitorConfigId: Monitors.generateId()
    property var currentMonitorToWSMap: {
        const currentMonitorConfigId = Monitors.generateId()
        const monitorToWSMap = Root.State.config.workspaces.monitorToWSMap
        const configExists = monitorToWSMap.hasOwnProperty(currentMonitorConfigId)
        if (!configExists) {
            const defaultMap = generateDefaultMonitorToWSMap()
            monitorToWSMap[currentMonitorConfigId] = defaultMap
            Root.State.configFileView.writeAdapter()
        }
        const current = monitorToWSMap[currentMonitorConfigId]
        return current
    }

    // Returns a Json object which creates a default map of each currently connected monitor
    // to an array of workspace IDs that are associated with it.
    function generateDefaultMonitorToWSMap(): var {
        let json = {}
        const monitors = Monitors.monitors
        console.log(monitors)
        console.log(Hyprland.monitors.values)
        let wsId = 1
        const workspacesPerMonitor = Math.floor(numWorkspaces / monitors.length)
        const leftoverWorkspaces = numWorkspaces % monitors.length
        monitors.forEach(monitor => {
            json[monitor.name] = []
            // Add any leftover workspaces to the first monitor
            const numWSToAddToMonitor = monitor.id === 0 ? workspacesPerMonitor + leftoverWorkspaces : workspacesPerMonitor
            for (let i=0; i < workspacesPerMonitor; i++) {
                json[monitor.name].push(wsId)
                wsId++
            }
        })
        console.log(`default monitor to workspace map: ${JSON.stringify(json)}`)
        return json
    }

    // Then we use wsToMonitorMap to lookup the current monitor set for each workspace in the gui
    // Changing the current monitor will modify wsToMonitorMap
    // Applying the config will reference wsToMonitorMap for the monitor to assign to each workspace
    
    // Inline component for a json workspace
    component Workspace: JsonObject {
        required property int wsId
        property bool isDefault: false
        property string name: ""
        //property string monitor: ""
        property int gapsin: 8
        property int gapsout: 16
        property bool rounding: true
    }

    // The workspaces.conf file
    FileView {
        id: wsConfFile
        path: Root.State.leafPath + "/hypr/workspaces.conf"
        onLoaded: {
            //console.log(`File ${path} load ok, text = ${text()}`) 
        }
    }

    function setWsName(text): void {
        const wsMap = Root.State.config.workspaces.wsMap
        root.selectedWorkspace.name = text
    }

    // Returns a Hyprland workspace config string for the current configuration  
    function generateHyprlandWsConf(): string {
        const wsMap = Root.State.config.workspaces.wsMap
        let conf = ''
        for (let id = 1; id <= numWorkspaces; id++) {
            const idStr = "ws" + id
            const ws = wsMap[idStr]
            // TODO: defaultName no work
            conf += `workspace = ${ws.wsId}, name:${ws.name}, monitor:${ws.monitor}, default:${ws.isDefault}, rounding:${ws.rounding}, gapsin:${ws.gapsin}, gapsout:${ws.gapsout}\n`
        }
        console.log(conf)
        return conf
    }

    // Returns a Json object which maps each currently connected monitor to an array of workspace IDs that are associated with it
    function generateMonitorToWsJson(): var {
        const wsMap = Root.State.config.workspaces.wsMap
        let json = {}
        for (let id = 1; id <= numWorkspaces; id++) {
            const idStr = "ws" + id
            const ws = wsMap[idStr]
            // Add the monitor for this ws as a key to the json if it's not already added
            if (!json.hasOwnProperty(ws.monitor)) {
                json[ws.monitor] = []
            }
            json[ws.monitor].push(ws.wsId)
        }
        return json
    }

    function saveWsConf() {

    }

    // Loads a workspace configuration
    // If a preset exists it will use that, otherwise it will use the default
    function loadWsConfig() {
        console.log(`setting workspace config`)
        const currentMonitorConfigId = Monitors.generateId()
        const wsConfMap = Root.State.config.workspaces.monitorToWSMap
        const configExists = wsConfMap.hasOwnProperty(currentMonitorConfigId)
        if (configExists) {
            const wsConfig = wsConfMap[currentMonitorConfigId]
            for (const monitor in wsConfig) {
                for (const wsId in wsConfig[monitor]) {
                    console.log(`moving ws ${wsId} to ${monitor}`)
                    Hyprland.dispatch(`moveworkspacetomonitor ${wsId} ${monitor}`)
                }
            }
        }
        else {
            console.log(`Workspace config for monitor config ${currentMonitorConfigId} was not found, using default`)
            // TODO: Setup default
        }
    }

    // Create and load the config specified in the workspace settings gui
    function applyWsConf() {
        console.log(`applying ws config`)
        // Generate the hyprland workspace conf
        const conf = generateHyprlandWsConf()
        // Write the new workspace configuration to the hyprland workspaces conf
        wsConfFile.setText(`# This file is autogenerated\n` + conf)

        // Write the current workspace to monitor mapping to the config
        //const monitorToWsMap = generateMonitorToWsJson()
        //Root.State.config.workspaces.monitorToWSMap[currentMonitorConfigId] = monitorToWsMap

        Root.State.configFileView.writeAdapter() // Need to manually write adapter since sub properties on inline json are not tracked

        console.log(`monitors id: ${currentMonitorConfigId}`)
        console.log(`monitorToWsMap: ${JSON.stringify(monitorToWsMap)}`)

        // Then load the new config
        loadWsConfig()

        // Need to refresh the workspaces in order for the qs hyprland service to update the ws obj's
        Hyprland.refreshWorkspaces()
    }

}
