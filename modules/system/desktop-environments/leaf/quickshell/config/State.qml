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
    property string colorsJsonPath: "/home/eXia/.config/leaf-de/quickshell-colors.json"
    property FileView configFileView: configFile
    property JsonAdapter config: configFile.adapter
    property JsonAdapter colors: colorFile.adapter

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
    property int rounding: 8
    property int smallSpace: 4
    property int mediumSpace: 8
    property int largeSpace: 10
    property double opacity: 0.8

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
        onFileChanged: {
            console.debug(`file changed`)
            reload()
        }

        // If the adapter's contents change, update the file
        onAdapterUpdated: {
            console.log(`Adapter updated for ${path}`)
            //writeAdapter() // Test this before re-enabling
        }

        onLoadFailed: (err) => console.error(`File load failed with ${err}`)
        onLoaded: console.log(`Config file load ok: ${path}`) 
        onSaveFailed: (err) => console.error(`File ${root.settingsJsonPath} save failed with ${err}`)
        onSaved: console.log(`Saved config file: ${path}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            
            /*
            property var aaa: ({
                value: "hi"
            })
            property string something: "THIS IS DEFAULT"
            */
            //property list<string> someStupidPropertyThatsNeededToMakeTheNextPropertyAfterItwork: []

            property var pinnedApps: [ "foot", "vesktop", "obsidian" ]
            property string pfpImagePath: "ababagb"
            property string newProp: "default"
            onNewPropChanged: console.debug(`newProp: ${newProp}`)
            Component.onCompleted: console.debug(`initall pfp: ${pfpImagePath}`)
            onPfpImagePathChanged: console.debug(`pfpImagePath: ${pfpImagePath}`)
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

    FileView {
        id: colorFile
        path: root.colorsJsonPath
        blockLoading: true
        // Reload the file if it changes
        watchChanges: true 
        onFileChanged: {
            console.debug(`file changed`)
            reload()
        }

        onLoadFailed: (err) => console.error(`File load failed with ${err}`)
        onLoaded: console.log(`Color file load ok: ${path}`) 
        onSaveFailed: (err) => console.error(`File ${root.settingsJsonPath} save failed with ${err}`)
        onSaved: console.log(`Saved color file: ${path}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        adapter: JsonAdapter {
            property color primary: "#9fd49c"
            property color on_primary: "#063911"
            property color primary_container: "#215026"
            property color on_primary_container: "#baf0b6"
            property color inverse_primary: "#39693b"
            property color primary_fixed: "#baf0b6"
            property color primary_fixed_dim: "#9fd49c"
            property color on_primary_fixed: "#002106"
            property color on_primary_fixed_variant: "#215026"

            property color secondary: "#b9ccb4"
            property color on_secondary: "#253424"
            property color secondary_container: "#3b4b39"
            property color on_secondary_container: "#d5e8cf"
            property color secondary_fixed: "#d5e8cf"
            property color secondary_fixed_dim: "#b9ccb4"
            property color on_secondary_fixed: "#101f10"
            property color on_secondary_fixed_variant: "#3b4b39"

            property color tertiary: "#a1ced5"
            property color on_tertiary: "#00363c"
            property color tertiary_container: "#1f4d53"
            property color on_tertiary_container: "#bcebf1"
            property color tertiary_fixed: "#bcebf1"
            property color tertiary_fixed_dim: "#a1ced5"
            property color on_tertiary_fixed: "#001f23"
            property color on_tertiary_fixed_variant: "#1f4d53"

            property color error: "#ffb4ab"
            property color on_error: "#690005"
            property color error_container: "#93000a"
            property color on_error_container: "#ffdad6"

            property color surface_dim: "#10140f"
            property color surface: "#10140f"
            property color surface_tint: "#9fd49c"
            property color surface_bright: "#363a34"
            property color surface_container_lowest: "#0b0f0a"
            property color surface_container_low: "#181d17"
            property color surface_container: "#1c211b"
            property color surface_container_high: "#272b25"
            property color surface_container_highest: "#323630"
            property color on_surface: "#e0e4db"
            property color on_surface_variant: "#c2c9bd"
            property color outline: "#8c9388"
            property color outline_variant: "#424940"
            property color inverse_surface: "#e0e4db"
            property color inverse_on_surface: "#2d322c"
            property color surface_variant: "#424940"

            property color background: "#10140f"
            property color on_background: "#e0e4db"
            property color shadow: "#000000"
            property color scrim: "#000000"
         
            property color blue_source: "#0000ff"
            property color blue_value: "#0000ff"
            property color blue: "#afc6ff"
            property color on_blue: "#142f60"
            property color blue_container: "#2d4578"
            property color on_blue_container: "#d9e2ff"
         
            property color red_source: "#ff0000"
            property color red_value: "#ff0000"
            property color red: "#ffb595"
            property color on_red: "#542105"
            property color red_container: "#713619"
            property color on_red_container: "#ffdbcd"
         
            property color green_source: "#00ff00"
            property color green_value: "#00ff00"
            property color green: "#a2d399"
            property color on_green: "#0c390e"
            property color green_container: "#255023"
            property color on_green_container: "#bdf0b3"

            property color source_color: "#1b8332"
        } 
    }
}
