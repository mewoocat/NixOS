pragma Singleton
import QtQuick
import Quickshell
import Niri 0.1

Singleton {
    property Niri plugin: Niri {
        id: niri
        Component.onCompleted: connect()
        
        onConnected: console.log("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Error:", error)
        }
    }
}
