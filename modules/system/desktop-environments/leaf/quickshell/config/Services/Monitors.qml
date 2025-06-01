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

    // Holds a list to each visual monitor element
    property list<var> visualMonitors: []

    property list<HyprlandMonitor> monitors: Hyprland.monitors.values

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            Hyprland.refreshMonitors()
            //console.log(`values: ${Hyprland.monitors.values}`)
            //console.log(`monitorObjs: ${root.monitorObjs}`)
            //monitorObjs = Hyprland.monitor.values.map(m => monitor.lastIpcObj)
            const id = root.generateId()
            if (monitorMapJson.adapter[id]) {
                console.log('found')
            }
            else {
                console.log('missed')
                monitorMapJson.adapter.huh2 = "hiii"
            }
        }
    }
    
    function applyConfig() {
        const id = generateId()
        console.log(`id: ${id}`)
        monitorMapJson.adapter[id] = generateHyprlandConf()
    }
    
    // Generate a unique idententifier for the current monitor configuration
    function generateId(): string {
        let id = ""
        Hyprland.refreshMonitors()
        for (let m of monitors) {
            m = m.lastIpcObject
            id = id + `${m.name}&${m.make}&${m.model}&${m.serial}`
        }
        console.log(id)
        return id
    }
    function generateHyprlandConf() {
        for (const v of visualMonitors) {
            const conf = `monitor=${v.monitor.name},preferred,${v.actualX}x${v.actualY},1`
            console.log(conf)
        }
    }
    function enable(){
        console.log('Enabling Monitor service')
        //generateId()
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
            console.log(`File ${path} load ok, text = ${monitorMapJson.text()}`) 

        }

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property var configs: {}
        }
        
    }
}
