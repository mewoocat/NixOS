pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string appOrderPath: "/home/eXia/.config/leaf-de/appOrder.json"
    
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

    /*
    FileView {
        id: appOrderFile
        path: root.appOrderPath

        // Block all operations until the file is loaded
        // I think this would be useful for not starting the weather api call until the lat/lon are read in (untested)
        blockLoading: true

        // Reload the file if it changes
        watchChanges: true 
        onFileChanged: reload()

        // If the adapter's contents change, update the file
        onAdapterUpdated: writeAdapter()

        onLoadFailed: (err) => {
            console.log(`File load failed with ${err}`)
        }
        onLoaded: {
            //console.log(`Load ok, text = ${configFile.text()}`) 
        }

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property JsonObject location: JsonObject {
                property real latitude: 0
                property real longitude: 0
            } 
            property string funImage: ""
        }
        
    }
    */
}
