pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.Services as Services
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs as Root

BarButton {
    id: buttonRoot
    visible: UPower.displayDevice.type !== UPowerDeviceType.Unknown
    icon.name: UPower.displayDevice.iconName
    text: `${Math.ceil(UPower.displayDevice.percentage * 100)}%`

    ContextMenu.onRequested: () => popupWindow.visible = true
    property Shared.PopupWindow popupWindow: Shared.PopupWindow {
        id: root
        property Item parentButton: buttonRoot // The button that this popup will be relative to

        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            item: parentButton
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Bottom | Edges.Left
        }

        content: ColumnLayout {
            id: menuContent
            spacing: 0

            ColumnLayout {
                //Layout.minimumWidth: 240
                RowLayout {
                    Shared.Icon {
                        source: Quickshell.iconPath("battery")
                    }
                    Shared.TextBlock {
                        text: "Power"
                        font.bold: true
                    }
                }    
                Shared.Seperator {
                    Layout.fillWidth: true
                }
                ColumnLayout {
                    Shared.TextBlock {
                        text: (Services.Power.charging
                            ? `Time to charged: \t ${Services.Power.timeToFull}` + '\n'
                            : `Time remaining: \t ${Services.Power.timeToEmpty}` + '\n')
                            + `Percent remaining: \t ${UPower.displayDevice.percentage * 100}%` + '\n'
                            + `Current energy: \t ${UPower.displayDevice.energy.toFixed(2)} Wh` + '\n'
                            + `Energy capacity: \t ${UPower.displayDevice.energyCapacity.toFixed(2)} Wh` + '\n'
                            + `Change rate: \t\t ${UPower.displayDevice.changeRate.toFixed(2)} W` + '\n'
                        font.pointSize: 10 
                        opacity: 0.6
                    }
                }
            }
        }
    }
}
