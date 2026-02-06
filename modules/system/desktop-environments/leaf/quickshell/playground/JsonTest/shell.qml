import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs as Root

FloatingWindow {

    FileView {
        id: fileView
        path: "/tmp/jsonAdapterTest.json"

        blockLoading: true
        watchChanges: true 
        onFileChanged: reload()

        adapter: JsonAdapter {
            id: jsonAdapter
            property var someObj: ({})
        }
    }

    property var obj: fileView.adapter.someObj

    function modifyValue() {
        console.log("source:" + JSON.stringify(fileView.adapter.someObj, null, 4))
        console.log("obj:" + JSON.stringify(obj, null, 4))
        obj["value"] = 9
        console.log("source:" + JSON.stringify(fileView.adapter.someObj, null, 4))
        console.log("obj:" + JSON.stringify(obj, null, 4))
        //Root.Test.fileView.writeAdapter()
    }

    Button {
        text: "action"
        onClicked: () => modifyValue()
    }
    Component.onCompleted: {
        //obj.value = "new value"
        //modifyValue()
    }
    //ColumnLayout {

    //    Text {
    //        text: fileView.adapter.someObj.thing
    //    }

    //    TextField {
    //        id: textField
    //    }
    //    
    //    Button {
    //        text: "accept"
    //        onClicked: {
    //            fileView.adapter.someObj.thing = textField.text
    //            fileView.writeAdapter()
    //        }
    //    }
    //}

    //FileView {
    //    id: fileView
    //    path: "/tmp/jsonAdapterTest.json"
    //    blockLoading: true
    //    watchChanges: true 
    //    onFileChanged: reload()
    //    onSaved: console.log(`file saved success`)
    //    onSaveFailed: console.log(`file saved failed`)
    //    onAdapterUpdated: {
    //        console.log(`Adapter updated.`)
    //        //writeAdapter()
    //    }
    //    adapter: JsonAdapter {
    //        property string test: "default value"
    //        property var someObj: ({
    //            thing: "default"
    //        })
    //        /*
    //        property TestJsonObject object1: TestJsonObject {
    //            something: 1
    //        }
    //        */
    //    }
    //}
}
