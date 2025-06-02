pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../" as Root
import "../Services" as Services

import Quickshell.Hyprland

Singleton {
    id: root
    component MonitorType: QtObject {
        property string name
        property int id
    }

    // Array of `hyprctl monitors -j` objects
    // Useful if properties of the HyprlandMonitor.lastIpcObject are needed
    /*
    property var monitorObjs: Hyprland.monitors.values.map(monitor => {
        Hyprland.refreshMonitors() // Is this not updating the prop before we access it?
        //console.log('property set')
        if (monitor.lastIpcObject === undefined) {
            return null
        }
        return monitor.lastIpcObject
    })
    */

    property list<var> visualMonitors: [] // Holds a list to each visual monitor element
    property list<HyprlandMonitor> monitors: Hyprland.monitors.values
 
    // Generate a unique idententifier for the current monitor configuration
    function generateId(): string {
        let id = ""
        Hyprland.refreshMonitors()
        for (let m of monitors) {
            const mObj = m.lastIpcObject
            if (m === undefined) {
                console.error("Error: lastIpcObject undefined for {}")
                return "???"
            }
            id = id + `${mObj.name}&${mObj.make}&${mObj.model}&${mObj.serial}-`
        }
        console.log(id)
        return id
    }
    // Returns a Hyprland monitor config string
    function generateHyprlandConf(): string {
        let conf = ''
        for (const v of visualMonitors) {
            conf += `monitor=${v.monitor.name},preferred,${v.actualX}x${v.actualY},1\n`
        }
        return conf
    }
    function applyConf() {
        const conf = generateHyprlandConf()
        const id = generateId()
        monitorMapFile.adapter.configs[id] = conf
        console.log(`qml: ${JSON.stringify(monitorMapFile.adapter)}`)
        // Write the changes to the file (needed since these properties on the js obj are not tracked)
        monitorMapFile.writeAdapter()
    }
    function enable(){
        console.log('Enabling Monitor service')
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            // TODO: Optimize when monitor event occurs
            Hyprland.refreshMonitors()
            /*
            const id = root.generateId() // Calculate the id for the currnet monitor conf
            if (monitorMapFile.adapter[id]) {
                console.log('found config')
            }
            else {
                console.log('missed config')
                //monitorMapJson.adapter[id] = generateHyprlandConf()
            }
            */
        }
    }

    FileView {
        id: monitorMapFile
        path: Root.State.leafPath + "/hypr/monitorMap.json"

        // Block all operations until the file is loaded
        blockLoading: true

        // Reload the file if it changes
        watchChanges: true 
        onFileChanged: reload()

        // If the adapter's contents change, update the file
        onAdapterUpdated: {
            console.log(`adapter updated`)
            writeAdapter()
        }

        onLoadFailed: (err) => {
            console.log(`File ${path} load failed with ${err}`)
        }
        onLoaded: {
            console.log(`File ${path} load ok, text = ${monitorMapFile.text()}`) 
        }

        // Adapter between qml object and json
        // Values set here are the defaults
        // *Note* This does not create the file with the default values.  It instead 
        // will use these values if they cannot be found in the specified file.
        adapter: JsonAdapter {
            // Empty object needs a value to not be interpreted as undefined
            property var configs: {"dummy": "value"} // map of id's to conf's
        }
        
    }
}
