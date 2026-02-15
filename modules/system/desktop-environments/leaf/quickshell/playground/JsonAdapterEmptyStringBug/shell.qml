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
        watchChanges: true
        onFileChanged: reload()

        adapter: JsonAdapter {            
            Component.onCompleted: console.debug(`initial pfp: ${pfpImagePath}`)
            onPfpImagePathChanged: console.debug(`pfpImagePath: ${pfpImagePath}`)

            property string pfpImagePath: "default"
            property JsonObject workspaces: JsonObject {
                property JsonObject wsMap: JsonObject {
                    property string what: "fuck"
                }
                property int num: 10
                property string a: "aaa"
                //property var inlineJson: { "a": "b" }
            }
            property var appFreqMap: ({})
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
