pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

//import qs.Services as Services
import "./Services/" as Services

Singleton {
    id: root

    property string leafPath: "/home/eXia/.config/leaf-de/"
    property string settingsJsonPath: "/home/eXia/.config/leaf-de/settings.json"
    property FileView configFileView: configFile
    property JsonAdapter config: configFile.adapter

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

    property bool screenLocked: false

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

    // There's definitely something fishy going on here
    // Might be due to using multiple json adapter instances
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
        onAdapterUpdated: {
            console.log(`Writing to ${path}`)
            console.log(`something state: ${adapter.something}`)
            //writeAdapter()
        }

        onLoadFailed: (err) => console.error(`File load failed with ${err}`)
        onLoaded: console.log(`Config file load ok: ${path}`) 
        onSaveFailed: (err) => console.error(`File ${root.settingsJsonPath} save failed with ${err}`)
        onSaved: console.log(`Saved config file: ${path}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property var aaa: ({
                value: "hi"
            })
            property string something: "THIS IS DEFAULT"
            property list<string> someStupidPropertyThatsNeededToMakeTheNextPropertyAfterItwork: []
            property list<string> pinnedApps: [ "foot", "vesktop", "obsidian" ]
            onPinnedAppsChanged: console.log(`pinnedApps now is: ${pinnedApps}`)
            property string pfpImage: ""
            property var appFreqMap: ({})

            property JsonObject location: JsonObject {
                property real latitude: 0
                property real longitude: 0
            } 

            property JsonObject appearance: JsonObject {
                property int rounding: 8
                property int gapsIn: 16
                property int gapsOut: 32
                property bool blur: false
            }

            // TODO: migrate config file to this
            //property string monitorMap: "{}" // Stores json of monitor configuration map
            //property string workspaceMap: "{}" // json for workspace config map

            property JsonObject workspaces: JsonObject {
                // Current workspace configuration (the literal values here are the default)
                // Note that the number of workspaces is hardcoded since using a JsonObject
                // type within a list causes a qs crash.  If a dynamic amount of workspaces is desired,
                // the maximum supported should be defined here and then each workspace should
                // have some sort of enabled property.
                // Alternatively a list of var type should also work but I prefer this approach for now
                property JsonObject wsMap: JsonObject {
                    property JsonObject ws1: Services.Hyprland.Workspace { wsId: 1; isDefault: true }
                    property JsonObject ws2: Services.Hyprland.Workspace { wsId: 2 }
                    property JsonObject ws3: Services.Hyprland.Workspace { wsId: 3 }
                    property JsonObject ws4: Services.Hyprland.Workspace { wsId: 4 }
                    property JsonObject ws5: Services.Hyprland.Workspace { wsId: 5 }
                    property JsonObject ws6: Services.Hyprland.Workspace { wsId: 6 }
                    property JsonObject ws7: Services.Hyprland.Workspace { wsId: 7 }
                    property JsonObject ws8: Services.Hyprland.Workspace { wsId: 8 }
                    property JsonObject ws9: Services.Hyprland.Workspace { wsId: 9 }
                    property JsonObject ws10: Services.Hyprland.Workspace { wsId: 10 }
                }

                // Map of monitor state to workspace configuration
                // Becomes populated with keys (which are a generated monitor config id)
                // and the associated values are a map of each monitor to a list of workspace ids assigned to that monitor
                // Example
                // { "monitorA-monitorB": " {"monitorA": [1,2,3,4,5], "monitorB": [6,7,8,9,10] }}
                // `()` fixes undefined issue when modifying
                property var monitorToWSMap: ({})
            }
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
