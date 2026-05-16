pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import qs as Root

Singleton {
    id: root 
    property ScriptModel items: ScriptModel {
        values: [... SystemTray.items.values]
    }
}
