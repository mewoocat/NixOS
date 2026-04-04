
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

FloatingWindow {

    FileView {
        id: fileView
        path: "/tmp/jsonAdapterTest.json"

        blockLoading: true
        watchChanges: true 
        onFileChanged: reload()

        adapter: JsonAdapter {
            id: jsonAdapter
            property JsonObject thing: JsonObject {
                property var inlineJson: {"a": "b"}
            }
        }
    }

    Button {
        text: "write"
        onClicked: () => fileView.writeAdapter()
    }
}
