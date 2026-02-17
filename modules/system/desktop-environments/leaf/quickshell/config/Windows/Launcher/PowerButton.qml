
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Services as Services
import qs.Modules.Leaf as Leaf

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
            Leaf.PopupMenuItem { text: "Shutdown"; action: () => Services.Power.shutdown(); iconName: "system-shutdown-symbolic"}
            Leaf.PopupMenuItem { text: "Hibernate"; action: () => Services.Power.hibernate(); iconName: "system-shutdown-symbolic"}
            Leaf.PopupMenuItem { text: "Restart"; action: () => Services.Power.restart(); iconName: "system-restart-symbolic"}
            Leaf.PopupMenuItem { text: "Sleep"; action: () => Services.Power.sleep(); iconName: "system-suspend-symbolic"}
        }
    }
}
