pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.Components.Shared as Shared

import "Windows"
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"
import "Windows/ActivityCenter"
import "Windows/Notifications"
import "Windows/Lockscreen"


Singleton {
    id: root

    function enable() {
        console.log(`starting leaf shell...`)
    }

    property string leafConfigDir: "/home/eXia/.config/leaf-de"
    property string settingsJsonPath: `${leafConfigDir}/settings.json`
    property string colorsJsonPath: `${leafConfigDir}/quickshell-colors.json`
    property FileView configFileView: configFile
    property JsonAdapter config: configFile.adapter
    property JsonAdapter colors: colorFile.adapter

    property bool screenLocked: false

    property bool launcherActive: false
    property bool controlPanelActive: false
    property bool activityCenterActive: false
    property PanelWindow dragOverlay: PanelWindow {
        color: "#00000033"
        anchors {
            left: true
            right: true
            top: true
            bottom: true
        }
        exclusionMode: ExclusionMode.Ignore
        mask: Region {
            item: area
            intersection: Intersection.Subtract
        }
        property Item areaItem: Item {
            id: area
            anchors.fill: parent
        }
        data: [
            areaItem
        ]
    }

    // Windows
    /*
    property Bar bar: Bar {} 
    property Launcher launcher: Launcher {}
    property ControlPanel controlPanel: ControlPanel {}
    property ActivityCenter activityCenter: ActivityCenter {}
    property Notifications notifications: Notifications {}
    property Lockscreen lockscreen: Lockscreen {}
    */
    property PromptWindow promptWindow: PromptWindow {}
        property bool promptVisibility: promptStack.length != 0
        property list<Component> promptStack: []
        onPromptStackChanged: {
            if (promptStack.length == 0) { promptVisibility = false }
            else { promptVisibility = true }
        }

    property Shared.Expander currentControlPanelPage: null

    
    // Styling
    property int rounding: 18
    property int smallRounding: 8
    property int innerRounding: rounding - windowPadding
    property int windowPadding: 8
    property int panelMargin: 8
    property int smallSpace: 4
    property int mediumSpace: 8
    property int largeSpace: 10
    property double opacity: 0.8
    property int barHeight: 32
    property string launcherIcon: "system-search-symbolic"//"distributor-logo-nixos"
    // Variable group lol
    /*
    property QtObject bar: QtObject {
        property int height: 40
    }
    */

    property int widgetUnitSize: 64


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

        onLoadFailed: (err) => console.error(`File load failed for: ${path} with ${err}`)
        onLoaded: console.info(`File load ok for: ${path}`) 
        onSaveFailed: (err) => console.error(`File save failed for: ${path} with ${err}`)
        onSaved: console.info(`File save ok for ${path}`)

        // Adapter between qml object and json
        // Values set here are the defaults
        //
        // Supported property types are:
        //    Primitves (int, bool, string, real)
        //    Sub-object adapters (JsonObject) (!! DOES NOT WORK FOR list<> !!)
        //    JSON objects and arrays, as a var type
        //    Lists of any of the above (list<string> etc)

        // Can be ignored, apparently due to a compilation speed up hack in Quickshell.
        // qmllint disable unresolved-type
        adapter: JsonAdapter {            
            property list<var> activityCenterWidgets: [
                {
                    uid: "Components/Widgets/Weather.qml",
                    xPosition: 0,
                    yPosition: 0
                }
            ]

            property var pfpImagePath: ""
            property var pinnedApps: ([ "foot", "vesktop", "obsidian" ])
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

            // WARNING: It appears that nesting an inline json property (i.e. `property var thing: { "a": 1 }`) inside
            // a JsonObject causes quickshell to crash.
        } 
    }

    FileView {
        id: colorFile
        path: root.colorsJsonPath
        blockLoading: true
        // Reload the file if it changes
        watchChanges: true 
        onFileChanged: {
            console.debug(`${path} changed`)
            reload()
        }

        onLoadFailed: (err) => console.error(`File load failed for: ${path} with ${err}`)
        onLoaded: console.info(`File load ok for: ${path}`) 
        onSaveFailed: (err) => console.error(`File save failed for: ${path} with ${err}`)
        onSaved: console.info(`File save ok for ${path}`)

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
