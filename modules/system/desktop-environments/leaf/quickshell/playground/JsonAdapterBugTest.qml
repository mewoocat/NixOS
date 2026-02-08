import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

FloatingWindow {

    Button {
        text: "action"
        onClicked: () => configFile.writeAdapter()
    }

    FileView {
        id: configFile
        path: "/tmp/test.json"
        blockLoading: true
        watchChanges: true 
        onFileChanged: reload()

        onLoadFailed: (err) => console.error(`File load failed with ${err}`)
        onLoaded: console.log(`Config file load ok: ${path}`) 
        onSaveFailed: (err) => console.error(`File ${root.settingsJsonPath} save failed with ${err}`)
        onSaved: console.log(`Saved config file: ${path}`)

        adapter: JsonAdapter {
            /*
            property var aaa: ({
                value: "hi"
            })
            property string something: "THIS IS DEFAULT"
            property list<string> someStupidPropertyThatsNeededToMakeTheNextPropertyAfterItwork: []

            property list<string> pinnedApps: [ "foot", "vesktop", "obsidian" ]
            */
            property string pfpImagePath: ""
            Component.onCompleted: console.debug(`initial pfpImagePath: ${pfpImagePath}`)
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
                //

                component Workspace: JsonObject {
                    // Meta data
                    property bool useGlobalConfig: true

                    required property int wsId
                    property bool isDefault: false
                    property string name: ""
                    //property string monitor: ""
                    property int gapsIn: -1 // -1 means use global
                    property int gapsOut: -1 // -1 means use global
                    property bool rounding: true
                }

                property JsonObject wsMap: JsonObject {
                    property JsonObject ws1: Workspace { wsId: 1; isDefault: true }
                    property JsonObject ws2: Workspace { wsId: 2 }
                    property JsonObject ws3: Workspace { wsId: 3 }
                    property JsonObject ws4: Workspace { wsId: 4 }
                    property JsonObject ws5: Workspace { wsId: 5 }
                    property JsonObject ws6: Workspace { wsId: 6 }
                    property JsonObject ws7: Workspace { wsId: 7 }
                    property JsonObject ws8: Workspace { wsId: 8 }
                    property JsonObject ws9: Workspace { wsId: 9 }
                    property JsonObject ws10: Workspace { wsId: 10 }
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
}
