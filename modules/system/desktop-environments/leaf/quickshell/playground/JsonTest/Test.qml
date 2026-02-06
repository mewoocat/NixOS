pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property JsonAdapter adapter: fileView.adapter
    property FileView fileView: fileView
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
}
