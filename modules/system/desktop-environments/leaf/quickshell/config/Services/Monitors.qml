pragma Singleton

import Quickshell
import QtQuick
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
        }
    }
    
    function generateId() {
        let id = ""
        /*
        for (const m of monitorObjs) {
            id = id + `${m.name}-${m.make}-${m.model}-${m.serial}`
        }
        */
        return id
    }
    function enable(){
        console.log('Enabling Monitor service')
        //generateId()
    }
}
