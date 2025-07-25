pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string leafPath: "/home/eXia/.config/leaf-de/"
    property string settingsJsonPath: "/home/eXia/.config/leaf-de/settings.json"
    property var config: configFile.adapter

    property bool launcherVisibility: false
    property bool controlPanelVisibility: false
    property bool activityCenterVisibility: false
    property bool workspacesVisibility: false

    // Window refs
    property var bar: null
    property var launcher: null
    property var controlPanel: null
    property var activityCenter: null
    property var workspaces: null
    property var settings: null

    //property list<QtObject> focusGrabIgnore: []
    property var panelGrab: null // The grab object for the active panel (old)
    property var popupGrab: null // The grab object for the active popup (old)
    property var activeGrab: null // The active grab object (either popup or panel) (new)

    // Index of the current page in control panel
    property int controlPanelPage: 0

    // Styling
    property int rounding: 12
    property int smallSpace: 4
    property int mediumSpace: 8
    property int largeSpace: 8


    FileView {
        id: configFile
        path: root.settingsJsonPath

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
            property list<string> pinnedApps: []
            property string pfpImage: ""
        }
        
    }

    /*
    FileView {
        id: jsonFile
        path: Qt.resolvedUrl(settingsJsonPath)
        // Forces the file to be loaded by the time we call JSON.parse().
        // see blockLoading's property documentation for details.
        blockLoading: true
        //blockAllReads: true
        //watchChanges: true
        //onFileChanged: this.reload()
        onLoadFailed: (err) => {
            console.log(`File load failed with ${err}`)
        }
        onLoaded: {
            console.log(`Load ok, text = ${jsonFile.text()}`) 
        }
    }

    readonly property var jsonData: {
        console.log("we getting here?")
        const data = JSON.parse(jsonFile.text())
        console.log("and here?")
        console.log(`Settingss: ${JSON.stringify(data)}`)
        return data
    }
    */

    //property var Bar: Bar {}
    /*
    Scope {
        id: windows
        property var bar: null
        property var launcher: null
        property var controlPanel: null
        property var activityCenter: null
    }
    */

    // Map of current window objects
    // Init'd to null and set within each window
    // WARNING: I think that if just one of the prop of this js obj is updated
    // that, it won't be reactive
    /*
    property var windows: {
        "Bar": null,
        "Launcher": null,
        "ControlPanel": null,
        "ActivityCenter": null,
    }
    */
}
