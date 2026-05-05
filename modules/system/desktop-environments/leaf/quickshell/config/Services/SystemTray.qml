pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Singleton {
    id: root 
    property list<SystemTrayItem> items: SystemTray.items.values
    /*
    property list<SystemTrayItem> mainItems: SystemTray.items.values.slice(0, 3) ?? []
    property list<SystemTrayItem> subItems: SystemTray.items.values.slice(3) ?? []
    */
}
