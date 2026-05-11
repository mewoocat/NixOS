pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs.Services as Services
import qs as Root
import "../"
import qs.Components.Shared.SequentialDragGrid as SeqDragGrid

RowLayout {
    id: root
    spacing: 0

    SeqDragGrid.SequentialDragGrid {
        tileHeight: dummy.height
        tileWidth: dummy.width
        Layout.preferredHeight: tileHeight
        Layout.preferredWidth: tileWidth * model.length
        model: Services.SystemTray.items
        onModelUpdated: (newModel) => {}
        // Warning! This is a hack to determine the size of a tray button in order to set the cell size
        property Item dummyTrayButton: SystemTrayButton {
            id: dummy
            trayItem: SystemTray.items[0]
        }
        delegate: SystemTrayButton {
            id: delegate
            required property SystemTrayItem modelData
            trayItem: modelData
        }
    }

    Item {
        Layout.fillHeight: true
        Layout.preferredWidth: 16
        Rectangle {
            anchors.centerIn: parent
            width: 2
            radius: 2
            height: parent.height - 16
            color: Root.State.colors.on_surface
            opacity: 0.7
        }
    }

    /*
    Repeater {
        model: Services.SystemTray.mainItems
        delegate: SystemTrayButton {
            required property SystemTrayItem modelData
            trayItem: modelData
        }
    }
    */

    /*
    // Toggle button
    BarButton {
        id: toggleButton
        contentItem.rotation: root.isExpanded ? 90 : 270
        onClicked: () => popup.visible = !popup.visible
        icon.name: "pan-start-symbolic"

        property Shared.PopupWindow overflowPopup: Shared.PopupWindow {
            id: popup
            anchor {
                // Only window or item should be set at a time, otherwise a crash can occur
                item: toggleButton
                edges: Edges.Bottom | Edges.Right
                gravity: Edges.Bottom | Edges.Left
                margins.left: -8
            }

            content: ColumnLayout {
                id: menuContent
                spacing: 0
                Repeater {
                    model: Services.SystemTray.subItems
                    delegate: SystemTrayButton {
                        required property SystemTrayItem modelData
                        trayItem: modelData
                    }
                }
            }
        }
    }
    */
}
