pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    function enable(){
        console.log("Enabling Hyprland Service")
    }
    property int activeWsId: Hyprland.focusedMonitor.activeWorkspace.id
    property var workspaceMap: {
        let map = {}
        Hyprland.workspaces.values.forEach(w => map[w.id] = w)
        return map
    }
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            Hyprland.refreshWorkspaces()
            console.log(event.name + " | " + event.data) 
            if (event.name === "workspace") {
                activeWsId = event.data
            } 
        }
    }
}
