pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import qs as Root

Singleton {
    id: root 
    property list<SystemTrayItem> items: [...SystemTray.items.values]
        .sort((a,b) => {
            console.log(`a: ${a.id}`)
            console.log(`systemTrayOrder: ${Root.State.config.systemTrayOrder}`)
            const indexA = Root.State.config.systemTrayOrder.indexOf(a.id)
            const indexAFound = indexA != -1
            const indexB = Root.State.config.systemTrayOrder.indexOf(b.id)
            const indexBFound = indexB != -1
            if (!indexAFound && !indexBFound) return 0 // If both not found then consider them equal
            if (!indexAFound) return 1 // Since only b has index then it is greater
            if (!indexBFound) return -1 // Since only a has index then it is greater
            const result = indexB - indexA // Sort descending
            return result
        })
    /*
    property list<SystemTrayItem> mainItems: SystemTray.items.values.slice(0, 3) ?? []
    property list<SystemTrayItem> subItems: SystemTray.items.values.slice(3) ?? []
    */
}
