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
        implicitHeight: 32
        implicitWidth: 200
        tileSize: 32
        model: Services.SystemTray.mainItems
        onModelUpdated: (newModel) => {
        }
        delegate: SystemTrayButton {
            required property SystemTrayItem modelData
            trayItem: modelData
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
}
