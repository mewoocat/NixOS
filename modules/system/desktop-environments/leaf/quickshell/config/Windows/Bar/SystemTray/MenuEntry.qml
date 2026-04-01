pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs as Root

// An item in a SystemTray popup menu
MouseArea {
    id: root
    // Note that it appears that some entry handles (i.e. for nm-applet) will become null at some point
    // important to check if null when referencing this entry property.
    // I've tried using a Loader to unload this component when entry is null but it doesn't appear to 
    // help with the null warning
    required property QsMenuEntry entry
    implicitHeight: background.height
    implicitWidth: box.width
    enabled: root.entry?.enabled ?? false
    hoverEnabled: root.entry?.enabled ?? false
    onClicked: {
        // setting the popup visibility if children exist
        if (root.entry?.hasChildren) { childrenLoader.item.item.visible = true }
        root.entry?.triggered()
    }

    // Loads a nested popup window if the entry supplies children
    Loader {
        id: childrenLoader
        active: root.entry?.hasChildren ?? false
        property Component trayPopupMenu: BoundComponent {
            id: trayPopup
            source: "TrayPopupMenu.qml"
            property var menu: root?.entry
            property Item parentButton: root
            property bool isNested: true
        }
        sourceComponent: trayPopupMenu
    }

    Rectangle {
        id: background
        color: root.containsMouse ? Root.State.colors.primary : "transparent"
        radius: Root.State.rounding
        implicitHeight: box.height
        implicitWidth: parent.width
        WrapperItem {
            id: box
            margin: 4

            RowLayout {
                id: content
                IconImage {
                    visible: root.entry?.hasChildren ?? false
                    implicitSize: root.entry?.hasChildren ? 16 : 0
                    source: Quickshell.iconPath("pan-start-symbolic")
                }
                // WARNING! This may log a Could not load icon warning for the following icons
                // - bluetooth-disabled-symbolic
                // - bluetooth-symbolic
                // - application-x-addon-symbolic
                IconImage {
                    visible: root.entry?.icon === ""
                    implicitSize: root.entry?.icon !== "" ? 16 : 0
                    source: root.entry?.icon ?? ""
                }
                CheckBox {
                    visible: root.entry?.buttonType === QsMenuButtonType.CheckBox
                    checkState: root.entry?.checkState ?? false
                }
                RadioButton {
                    visible: root.entry?.buttonType === QsMenuButtonType.RadioButton
                }
                Text { 
                    id: text
                    color: {
                        if (!root.entry?.enabled) return Root.State.colors.red
                        if (root.containsMouse) return Root.State.colors.on_primary
                        return Root.State.colors.on_surface
                    }
                    text: root.entry?.text ?? ""
                }
            }
        }
    }
}
