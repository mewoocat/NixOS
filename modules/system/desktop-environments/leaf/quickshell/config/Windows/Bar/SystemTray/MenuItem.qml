pragma ComponentBehavior: Bound
import qs.Components.Controls as Ctrls
import Quickshell
import QtQuick

Ctrls.MenuItem {
    id: root
    required property QsMenuEntry menuEntry
    text: menuEntry.text
    onClicked: {
        // TODO: idk why this works
        if (root.menuEntry?.hasChildren) { childLoader.item.item.visible = true }
        root.menuEntry?.triggered()
        console.debug(`hasChildren ${menuEntry.hasChildren}`)
        console.debug(`menu ${menuEntry}`)
    }
    // Loads a nested popup window if the entry supplies children
    Loader {
        id: childLoader
        active: root.menuEntry.hasChildren
        property Component childMenu: BoundComponent {
            source: "TrayPopupMenu.qml"
            property QsMenuHandle menuHandle: root.menuEntry
            property Item parentButton: root
        }
        sourceComponent: childMenu
    }
}
