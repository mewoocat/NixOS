pragma ComponentBehavior: Bound
import qs.Components.Controls as Ctrls
import Quickshell
import QtQuick

Ctrls.MenuItem {
    id: root
    // Note that it appears that some entry handles (i.e. for nm-applet) will become null at some point
    // important to check if null when referencing this menuEntry property.
    // I've tried using a Loader to unload this component when entry is null but it doesn't appear to 
    // help with the null warning
    required property QsMenuEntry menuEntry 
    text: menuEntry?.text ?? "..."
    checkable: menuEntry?.buttonType === QsMenuButtonType.CheckBox
    checked: menuEntry?.checkState === Qt.Checked
    hasChildren: menuEntry?.hasChildren ?? false
    onClicked: {
        // NOTE: The loaded item here is actually a BoundComponent instance.  So the second item property
        // is the item of the BoundComponent
        if (root.menuEntry?.hasChildren) { childLoader.item.item.visible = true }
        root.menuEntry?.triggered()
    }
    // Loads a nested popup window if the entry supplies children
    Loader {
        id: childLoader
        active: root.menuEntry?.hasChildren ?? false
        // Using BoundComponent to avoid a cyclic dependency error
        property Component childMenu: BoundComponent {
            source: "TrayPopupMenu.qml"
            property QsMenuHandle menuHandle: root.menuEntry
            property Item parentButton: root
        }
        sourceComponent: childMenu
    }
}
