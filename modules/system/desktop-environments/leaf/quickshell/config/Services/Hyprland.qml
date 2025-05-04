pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    function enable(){
        console.log("Enabling Hyprland Service")
    }
    property int activeWsId: Hyprland.focusedMonitor.activeWorkspace.id
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            console.log(event.name + " | " + event.data)
            
            if (event.name === "workspace") {
                activeWsId = event.data
            }
        }
    }
}
