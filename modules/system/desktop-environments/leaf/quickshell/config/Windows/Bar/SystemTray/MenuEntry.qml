pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs as Root

// An item in a SystemTray popup menu
Loader {
    id: root
    // Note that it appears that some entry handles (i.e. for nm-applet) will become null at some point
    // important to check if null when referencing this entry property.
    // So that's why this is wrapped in a Loader
    required property QsMenuEntry entry
    active: entry != null

    sourceComponent: MouseArea {
        id: mouseArea
        implicitHeight: background.height
        implicitWidth: box.width
        enabled: root.entry.enabled
        hoverEnabled: root.entry.enabled
        onClicked: {
            // setting the popup visibility if children exist
            if (root.entry.hasChildren) { childrenLoader.item.item.visible = true }
            root.entry.triggered()
        }

        // Loads a nested popup window if the entry supplies children
        Loader {
            id: childrenLoader
            active: root.entry.hasChildren
            property Component trayPopupMenu: BoundComponent {
                id: trayPopup
                source: "TrayPopupMenu.qml"
                property var menu: root.entry
                property Item parentButton: root
                property bool isNested: true
            }
            sourceComponent: trayPopupMenu
        }

        Rectangle {
            id: background
            color: mouseArea.containsMouse ? Root.State.colors.primary : "transparent"
            radius: Root.State.rounding
            implicitHeight: box.height
            implicitWidth: parent.width
            WrapperItem {
                id: box
                margin: 4
                // This doesn't prevent the entry is null warnings that occur at runtime :(
                Loader {
                    active: root.entry !== null
                    onActiveChanged: console.log(`active now ${active}`)
                    sourceComponent: BoundComponent {
                        bindValues: false
                        property QsMenuEntry entry: root.entry
                        sourceComponent: RowLayout {
                            id: content
                            required property QsMenuEntry entry
                            IconImage {
                                visible: content.entry.hasChildren
                                implicitSize: content.entry.hasChildren ? 16 : 0
                                source: Quickshell.iconPath("pan-start-symbolic")
                            }
                            // WARNING! This may log a Could not load icon warning for the following icons
                            // - bluetooth-disabled-symbolic
                            // - bluetooth-symbolic
                            // - application-x-addon-symbolic
                            IconImage {
                                visible: content.entry.icon === ""
                                implicitSize: content.entry.icon !== "" ? 16 : 0
                                source: content.entry.icon
                            }
                            CheckBox {
                                visible: content.entry.buttonType === QsMenuButtonType.CheckBox
                                checkState: content.entry.checkState
                            }
                            RadioButton {
                                visible: content.entry.buttonType === QsMenuButtonType.RadioButton
                                // TODO: this no work
                                background: Rectangle {
                                    color: "red"
                                }
                            }
                            Text { 
                                id: text
                                color: {
                                    if (!content.entry.enabled) return Root.State.colors.red
                                    if (mouseArea.containsMouse) return Root.State.colors.on_primary
                                    return Root.State.colors.on_surface
                                }
                                text: content.entry.text
                            }
                        }
                    }
                }
            }
        }
    }
}
