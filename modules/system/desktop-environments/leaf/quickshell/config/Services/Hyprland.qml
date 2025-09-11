pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs as Root

Singleton {
    id: root

    property int numWorkspaces: 10
    property int activeWsId: {
        if (Hyprland.focusedMonitor === null) {
            return 1
        }
        return Hyprland.focusedMonitor.activeWorkspace.id
    }
    property var workspaceMap: {
        let map = {}
        Hyprland.workspaces.values.forEach(w => {
            map[w.id] = w
            //console.log(`ws ${w.id}: ` + map[w.id])
        })
        return map
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            // TODO: Optimize pls
            Hyprland.refreshWorkspaces()
            Hyprland.refreshMonitors()
            //Hyprland.refreshToplevels() // Clients // CAUSES CRASH IF SPAMMED
            
            //console.log(event.name + " | " + event.data) 
            if (event.name === "workspacev2") {
                //console.log(`event = ${JSON.stringify(event)}`)
                activeWsId = event.data.split(',')[0]
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
            //console.log(`activeGrabWindow was not null and is ${root.activeGrabWindow}`)
            root.focusGrabStack.push(root.activeGrabWindow)
            //console.log(`focus grab stack ${root.focusGrabStack}`)
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
            //console.log('grab active for ' + root.activeGrabWindow)
            //grab.active = root.activeGrabWindow.visible
            grab.active = true
        }
    }

    // A single focus grab instance which is shared
    HyprlandFocusGrab {
        id: grab
        active: false
        //onActiveChanged: console.log(`grab.active = ${active}`)
        windows: root.ignoredGrabWindows
        // Function to run when the Cleared signal is emitted
        onCleared: () => {
            //console.log(`clearing grab for ${root.activeGrabWindow}`)
            root.activeGrabWindow.closeWindow() // Assumes this method exists
            grab.active = false

            // Revert to the previous grab context
            if (root.focusGrabStack.length > 0) {
                //console.log(`focus grab stack ${root.focusGrabStack}`)
                const previousGrabWindow = root.focusGrabStack.pop()
                //console.log(`reverting focus grab to ${previousGrabWindow}`)
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
    property int selectedWsGapsOut: selectedWorkspace.gapsOut === -1 ? Root.State.config.appearance.gapsOut : selectedWorkspace.gapsOut
    property int selectedWsGapsIn: selectedWorkspace.gapsIn === -1 ? Root.State.config.appearance.gapsIn : selectedWorkspace.gapsIn

    property var currentMonitorToWSMap: {
        const currentMonitorConfigId = Monitors.currentMonitorConfigId
        const monitorToWSMap = Root.State.config.workspaces.monitorToWSMap
        const configExists = monitorToWSMap.hasOwnProperty(currentMonitorConfigId)
        if (!configExists) {
            console.warn(`Workspace config for monitor config ${currentMonitorConfigId} was not found, auto generating default`)
            monitorToWSMap[currentMonitorConfigId] = generateDefaultMonitorToWSMap()
        }
        const current = monitorToWSMap[currentMonitorConfigId]
        return current
    }

    // Takes in a string for the monitor name
    function assignSelectedWorkspaceToMonitor(monitorName): void {
        //console.log(`Assigning ${selectedWorkspaceId} to ${monitorName}`)
        // Find and remove the current workspace from the monitor it's assigned to
        for (let monitor in currentMonitorToWSMap) {
            if (currentMonitorToWSMap[monitor].includes(selectedWorkspaceId)) {
                //console.log(`${selectedWorkspaceId} is in ${monitor}`)
                const indexOfWorkspaceToRemove = currentMonitorToWSMap[monitor].indexOf(selectedWorkspaceId)
                //console.log(`index is ${indexOfWorkspaceToRemove}`)
                //console.log(`current monitor assignments ${currentMonitorToWSMap[monitor]}`)
                currentMonitorToWSMap[monitor].splice(indexOfWorkspaceToRemove, 1)
                //console.log(`new monitor assignments ${currentMonitorToWSMap[monitor]}`)
                break
            }
        }
        
        // Assign the current workspace to the new monitor
        currentMonitorToWSMap[monitorName]
            .push(selectedWorkspaceId)
            //.sort((a, b) => a - b) // Sort ascending
    }

    function getMonitorFromName(monitorName): HyprlandMonitor {
        for (let monitor of Hyprland.monitors.values) {
            if (monitor.name === monitorName) {
                return monitor
            }
        }
        console.error(`No monitor was found with the name ${monitorName}`)
        return null
    }

    // Takes in an id string for a workspace
    // Returns the monitor name string
    function getMonitorForWorkspace(wsId): string {
        for (let monitor in currentMonitorToWSMap) {
            const assignedWorkspaces = currentMonitorToWSMap[monitor]
            if (assignedWorkspaces.includes(wsId)) {
                return monitor
            }
        }
        return "ERROR: workspace is not assigned a monitor :("
    }

    // Returns a Json object which creates a default map of each currently connected monitor
    // to an array of workspace IDs that are associated with it.
    // Works by assigning the same number of workspaces to each monitor and then any
    // leftovers to the first monitor
    function generateDefaultMonitorToWSMap(): var {
        let json = {}
        const monitors = Monitors.monitors
        //console.log(monitors)
        //console.log(Hyprland.monitors.values)
        let wsId = 1
        const workspacesPerMonitor = Math.floor(numWorkspaces / monitors.length)
        const leftoverWorkspaces = numWorkspaces % monitors.length
        monitors.forEach(monitor => {
            json[monitor.name] = []
            // Add any leftover workspaces to the first monitor
            const numWSToAddToMonitor = monitor.id === 0 ? workspacesPerMonitor + leftoverWorkspaces : workspacesPerMonitor
            for (let i=0; i < numWSToAddToMonitor; i++) {
                json[monitor.name].push(wsId)
                wsId++
            }
        })
        //console.log(`default monitor to workspace map: ${JSON.stringify(json)}`)
        return json
    }

    // Then we use wsToMonitorMap to lookup the current monitor set for each workspace in the gui
    // Changing the current monitor will modify wsToMonitorMap
    // Applying the config will reference wsToMonitorMap for the monitor to assign to each workspace
    
    // Inline component for a json workspace
    component Workspace: JsonObject {
        // Meta data
        property bool useGlobalConfig: true

        required property int wsId
        property bool isDefault: false
        property string name: ""
        //property string monitor: ""
        property int gapsIn: -1 // -1 means use global
        property int gapsOut: -1 // -1 means use global
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
            const monitorName = getMonitorForWorkspace(ws.wsId)
            const gapsIn = ws.gapsIn === -1 ? Root.State.config.appearance.gapsIn : ws.gapsIn
            const gapsOut = ws.gapsOut === -1 ? Root.State.config.appearance.gapsOut : ws.gapsOut
            console.log(`gapsIn: ${gapsIn} | gapsOut: ${gapsOut}`)
            // WARNING: Setting name and defaultName cause weird hyprland workspace behavior if empty
            // The persistent rule is needed to know workspace properties when it's not active (i.e. rendering the size of an empty workspace in the overview)
            conf += `workspace = ${ws.wsId}, monitor:${monitorName}, default:${ws.isDefault}, persistent:true, rounding:${ws.rounding}, gapsin:${gapsIn}, gapsout:${gapsOut}\n`
        }
        //console.log(conf)
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

    // Loads the current monitor to workspace configuration
    // If a preset exists it will use that, otherwise it will use the default
    function loadMonitorToWSConfig() {
        //console.log(`loading monitor to workspace config`)
        for (let monitor in currentMonitorToWSMap) {
            //console.log(`workspaes for monitor ${monitor} = ${currentMonitorToWSMap[monitor]}`)
            for (let wsId of currentMonitorToWSMap[monitor]) {
                //console.log(`moving ws ${wsId} to ${monitor}`)
                Hyprland.dispatch(`moveworkspacetomonitor ${wsId} ${monitor}`)
            }
        }
    }

    // Create and load the config specified in the workspace settings gui
    function applyWsConf() {
        //console.log(`applying ws config`)
        // Generate the hyprland workspace conf
        const conf = generateHyprlandWsConf()
        // Write the new workspace configuration to the hyprland workspaces conf
        wsConfFile.setText(`# This file is autogenerated\n` + conf)

        // Write the current workspace to monitor mapping to the config
        //const monitorToWsMap = generateMonitorToWsJson()
        //Root.State.config.workspaces.monitorToWSMap[currentMonitorConfigId] = monitorToWsMap

        Root.State.configFileView.writeAdapter() // Need to manually write adapter since sub properties on inline json are not tracked

        //console.log(`monitors id: ${Monitors.currentMonitorConfigId}`)
        //console.log(`monitorToWsMap: ${JSON.stringify(monitorToWsMap)}`)

        // Load monitor to workspace config (in case any workspace -> monitor assignment has changed)
        loadMonitorToWSConfig()

        // Need to refresh the workspaces in order for the qs hyprland service to update the ws obj's
        Hyprland.refreshWorkspaces()
    }

}
