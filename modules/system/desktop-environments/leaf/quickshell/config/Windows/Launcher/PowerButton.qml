
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Services as Services
import qs.Modules.Leaf as Leaf
import qs.Components.Controls as Ctrls

// Power options popup menu
SidePanelItem {
    id: power
    imgName: 'system-shutdown-symbolic'
    imgSize: 22
    onLeftClick: () => {
        console.log("click")
        powerPopup.visible = true
    }
    Leaf.PopupWindow {
        id: powerPopup

        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            //window: launcher
            item: power
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
        }

        content: ColumnLayout {
            //Rectangle { implicitHeight:1; implicitWidth:1 }
            /*
            WrapperMouseArea {
                hoverEnabled: true
                Rectangle {
                    color: parent.containsMouse ? "red" : "green"
                    implicitWidth: 40
                    implicitHeight: 20
                }
            }
            WrapperMouseArea {
                hoverEnabled: true
                Rectangle {
                    color: parent.containsMouse ? "red" : "green"
                    implicitWidth: 40
                    implicitHeight: 20
                }
            }
            WrapperMouseArea {
                hoverEnabled: true
                Rectangle {
                    color: parent.containsMouse ? "red" : "green"
                    implicitWidth: 40
                    implicitHeight: 20
                }
            }
            Ctrls.Button { text: "what" }
            Ctrls.MenuItemTest { text: "Shutdown"; onClicked: () => Services.Power.shutdown(); icon.name: "system-shutdown-symbolic"}
            Ctrls.MenuItemTest { text: "Hibernate"; onClicked: () => Services.Power.hibernate(); icon.name: "system-shutdown-symbolic"}
            Ctrls.MenuItemTest { text: "Restart"; onClicked: () => Services.Power.restart(); icon.name: "system-restart-symbolic"}
            */
            Ctrls.MenuItem { text: "Sleep"; onClicked: () => Services.Power.sleep(); icon.name: "system-suspend-symbolic"}
            Ctrls.MenuItem { text: "Shutdown"; onClicked: () => Services.Power.shutdown(); icon.name: "system-shutdown-symbolic"}
            Ctrls.MenuItem { text: "Shutdown"; onClicked: () => Services.Power.shutdown(); icon.name: "system-shutdown-symbolic"}
        }
    }
}
