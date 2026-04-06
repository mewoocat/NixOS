import Quickshell
import Quickshell.Io
import QtQuick
import qs as Root

Item {
    id: root
    property FileView configFile: configFile

    FileView {
        id: configFile
        path: `${Root.State.leafPath}/widget-test.json`
        blockLoading: true // Block all operations until the file is loaded
        watchChanges: true // Reload the file if it changes
        onFileChanged: {
            console.debug(`config file: ${path} changed`)
            reload()
        }

        // If the adapter's contents change, update the file
        onAdapterUpdated: {
            console.log(`Adapter updated for ${path}`)
            //writeAdapter() // Test this before re-enabling
        }

        onLoadFailed: (err) => console.error(`File ${path} load failed with ${err}`)
        onLoaded: console.log(`Config file load ok: ${path}`) 
        onSaveFailed: (err) => console.error(`File ${path} save failed with ${err}`)
        onSaved: console.log(`Saved config file: ${path}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {            
            property var widgetData: [
                {
                    uid: "Components/Widgets/Weather.qml",
                    xPosition: 0,
                    yPosition: 0
                }
            ]
        } 
    }
}
