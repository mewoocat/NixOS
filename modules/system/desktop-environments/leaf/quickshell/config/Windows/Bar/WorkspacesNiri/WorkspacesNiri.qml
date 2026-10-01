pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Services as Services

// Idealy this would be done using the generic approach but Quickshell's Windowset and Toplevel types are not feasibly associatable.
WrapperMouseArea {
    id: root
    required property ShellScreen screen
    hoverEnabled: true

    RowLayout {
        spacing: 0

        Repeater {
            id: wsRepeater
            // Only show workspaces for this screen
            model: SortFilterProxyModel {
                model: Services.Niri.workspaces
                filters: [
                    FunctionFilter {
                        component RoleData: QtObject { property string output }
                        function filter(ws: RoleData): bool {
                            console.debug(`ws: ${ws.output} screen: ${root.screen.name}`)
                            return ws.output === root.screen.name
                        }
                    }
                ]
                // sorters: [	
                //     component RoleData: QtObject { property string workspaceId }
                //     FunctionSorter
                //         .sort((a, b) => {
                //             if (a.coordinates[1] > b.coordinates[1]) return 1
                //             return -1
                //         })
                // ]
            }
            delegate: WsButtonAppList {
                id: workspaceButton
                required property var modelData
                required property int index
                ws: modelData
                isLast: index + 1 === wsRepeater.model.length
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }
        }
    }
}
