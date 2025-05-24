pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    function enable(){
        console.log("Enabling Hyprland Service")
    }
    property int activeWsId: Hyprland.focusedMonitor.activeWorkspace.id
    property var workspaceMap: {
        let map = {}
        Hyprland.workspaces.values.forEach(w => {
            map[w.id] = w
            //console.log("ws: " + map[w.id])
        })
        return map
    }

    // Map of workspace id's to array of client objects
    property var clientMap: {}
    Process {
        id: clientProc
        command: ["sh", "-c", "hyprctl clients -j"]
        running: true
        stdout: SplitParser {
            splitMarker: ""
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

            // TODO: optimize when this is ran
            clientProc.running = true
            
            //console.log(event.name + " | " + event.data) 
            if (event.name === "workspace") {
                activeWsId = event.data
            } 
        }
    }
}
