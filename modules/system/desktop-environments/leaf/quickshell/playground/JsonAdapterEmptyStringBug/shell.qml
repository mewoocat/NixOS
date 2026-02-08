import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    id: root
    property FileView file: FileView {
        id: configFile
        path: "/tmp/qs-test.json"

        adapter: JsonAdapter {            
            Component.onCompleted: console.debug(`initial pfp: ${pfpImagePath}`)
            onPfpImagePathChanged: console.debug(`pfpImagePath: ${pfpImagePath}`)

            property var pinnedApps: [ "foot", "vesktop", "obsidian" ]

            property string pfpImagePath: "default"

            property JsonObject workspaces: JsonObject {
                property JsonObject wsMap: JsonObject {}
                property var monitorToWSMap: ({})
            }
        } 
    }

    FloatingWindow {
        ColumnLayout {
            Button {
                text: "write adapter"
                onClicked: root.file.writeAdapter()
            }
            Button {
                text: "change property"
                onClicked: root.file.adapter.pfpImagePath = "new value"
            }
            Text {
                text: `property: ${root.file.adapter.pfpImagePath}`
            }
        }
    }
}
