pragma Singleton

import Quickshell
import Quickshell.Io
import qs as Root

Singleton {
    id: root
    property string appOrderPath: "/home/eXia/.config/leaf-de/appOrder.json"

    //property var appFreqMap: appOrderFile.adapter.appFreqMap // busted?
    property var appFreqMap: Root.State.config.appFreqMap
    
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

    // Warning!! 
    // From testing it appears that when you have FileView with a JsonAdapter and a native JS
    // object as one of the properties on the adapter, some strange behavior happens when the 
    // file exists on disk and is loaded in.  If you have a direct reference to the adapter
    // (not via a binding) then everything behaves normal if you modify an arbitrary sub property
    // on the JS object.  However if you have a binding to the object on the adapter and then 
    // modify an arbitrary sub property, it will modify the sub property if you reference
    // the adapter via the binding, but referencing the JS object directly from the adapter
    // shows the sub property as not updating.  This causes writeAdapter() to not write anything
    // to the json file.  However, if the file doesn't exist on disk, then this issue doesn't 
    // occur.  And yes, I triple checked that the binding is by reference under normal
    // circumstances.  It just appears that at some point, the binding to the JS object on
    // the adapter becomes a copy or something.  But only if the file exists on disk.
    function incrementFreq(appId): void {    
        console.debug(`incrementingFreq() call with ${appId}`)
        const currentFreq = root.appFreqMap[appId] ?? 0
        console.debug(`currentFreq: ${currentFreq}`)
        appFreqMap[appId] = currentFreq + 1
        console.debug(`appFreqMap["${appId}"]: ${appFreqMap[appId]}`)
        console.debug("local: " + JSON.stringify(root.appFreqMap, null,4 ))
        console.debug("Root: " + JSON.stringify(Root.State.config.appFreqMap, null,4 ))
        // Write the changes to the file (needed since these properties on the js obj are not tracked)
        //appOrderFile.writeAdapter() // Known bug which sometimes crashes, waiting for fix
        console.debug(`TRYING TO WRITE ADAPTER`)
        console.debug(`json adapter: ${Root.State.configFileView.writeAdapter()}`)

        // Works
        //let obj = Root.State.config.aaa
        //obj.value = "new value"
        //Root.State.config.aaa = obj
        
        Root.State.config.aaa.value = "what"

        Root.State.configFileView.writeAdapter()
    }
    
    function findDesktopEntryById(id: string): DesktopEntry {
        return DesktopEntries.applications.values.find(entry => entry.id === id)
    }

    /*
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
            console.log(`Loaded ${root.appOrderPath}`) 
        }
        onSaved: console.log(`Saved: ${root.appOrderPath}`)
        //onSavedFailed: console.error(`Failed to save: ${root.appOrderPath}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property var appFreqMap: ({}) // Wrap in () to indicate js object and not a qml one
        }
        
    }
    */
}
