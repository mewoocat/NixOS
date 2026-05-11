pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import qs as Root

Singleton {
    id: root 
    property list<SystemTrayItem> items: [...SystemTray.items.values]
    /*
        .sort((a,b) => {
            const indexA = Root.State.config.systemTrayOrder.findIndex(a.id)
            console.log(`a: ${indexA}`)
            const indexAFound = indexA != -1
            const indexB = Root.State.config.SystemTrayOrder.findIndex(b.id)
            const indexBFound = indexB != -1
            if (!indexAFound && !indexBFound) return 0 // If both not found then consider them equal
            if (!indexAFound) return 1 // Since only b has index then it is greater
            if (!indexBFound) return -1 // Since only a has index then it is greater
            return indexB - indexA // Sort descending
        })
    */
    /*
    property list<SystemTrayItem> mainItems: SystemTray.items.values.slice(0, 3) ?? []
    property list<SystemTrayItem> subItems: SystemTray.items.values.slice(3) ?? []
    */
}
