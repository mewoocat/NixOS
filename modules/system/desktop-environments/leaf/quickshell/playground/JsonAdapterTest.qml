import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

FloatingWindow {

    component TestJsonObject: JsonObject {
        required property int something
        property string what: "hello"
    }

    FileView {
        id: fileView
        path: "/tmp/jsonAdapterTest.json"
        blockLoading: false
        watchChanges: true 
        onFileChanged: reload()
        onAdapterUpdated: {
            console.log(`Writing to ${path}`)
            writeAdapter()
        }
        adapter: JsonAdapter {
            property string test: "default value"
            property int testNumber: 999
            property TestJsonObject object1: TestJsonObject {
                something: 1
            }
            property TestJsonObject object2: TestJsonObject {
                something: 2
                what: "aaa"
            }
        }
    }
    TextField {
        onTextChanged: {
            console.log(`changing test to ${text}`)
            fileView.adapter.object1.what = text
        }
    }
}
