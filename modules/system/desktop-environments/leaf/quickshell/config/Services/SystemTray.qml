pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import qs as Root

Singleton {
    id: root 
    property ScriptModel items: ScriptModel {
        values: [...SystemTray.items.values]
            .sort((a,b) => {
                const indexA = Root.State.config.systemTrayOrder.indexOf(a.id)
                const indexAFound = indexA != -1
                const indexB = Root.State.config.systemTrayOrder.indexOf(b.id)
                const indexBFound = indexB != -1
                console.log(`a: ${a.id} with index ${indexA}`)
                console.log(`b: ${b.id} with index ${indexB}`)
                if (!indexAFound && !indexBFound) {
                    return 0 // If both not found then consider them equal
                }
                if (!indexAFound) return 1 // Since only b has index then it is greater
                if (!indexBFound) return -1 // Since only a has index then it is greater
                const result = indexA - indexB // Sort ascending
                return result
            })
    }
    /*
    property list<SystemTrayItem> mainItems: SystemTray.items.values.slice(0, 3) ?? []
    property list<SystemTrayItem> subItems: SystemTray.items.values.slice(3) ?? []
    */
}
