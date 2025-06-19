pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string appOrderPath: "/home/eXia/.config/leaf-de/appOrder.json"

    property var appFreqMap: appOrderFile.adapter.appFreqMap
    
    // Used to make a client name more human readable
    // TODO: Refractor
    function formatClientName(input: string): string {
        if (input.startsWith("org.") || input.startsWith("com.")){
            let pathList = input.split('.')
            input = pathList[pathList.length - 1]
        }
        if (input.length > 0){
            return input[0].toUpperCase() + input.slice(1)
        }
        return "?"
    }

    function incrementFreq(appId): void {    
        const currentFreq = root.appFreqMap[appId] || 0
        appFreqMap[appId] = currentFreq + 1
        // Write the changes to the file (needed since these properties on the js obj are not tracked)
        appOrderFile.writeAdapter() // Known bug which sometimes crashes, waiting for fix
    }
    
    function findDesktopEntryById(id: string): DesktopEntry {
        return DesktopEntries.applications.values.find(entry => entry.id === id)
    }

    FileView {
        id: appOrderFile
        path: root.appOrderPath

        // Block all operations until the file is loaded
        blockLoading: true

        // Reload the file if it changes
        watchChanges: true 
        onFileChanged: reload()

        // If the adapter's contents change, update the file
        onAdapterUpdated: {
            console.log("app freq map changed")
            writeAdapter()
        }

        onLoadFailed: (err) => {
            console.log(`File load failed with ${err}`)
        }
        onLoaded: {
            //console.log(`Loaded ${root.appOrderPath} text = ${appOrderFile.text()}`) 
        }

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property var appFreqMap: ({}) // Wrap in () to indicate js object and not a qml one
        }
        
    }
}
