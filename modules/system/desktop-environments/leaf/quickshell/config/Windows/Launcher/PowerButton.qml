pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

// Power options popup menu
Shared.PanelButton {
    id: power
    icon.name: 'system-shutdown-symbolic'
    //imgSize: 22
    onClicked: () => powerPopup.visible = !powerPopup.visible
    Shared.PopupWindow {
        id: powerPopup

        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            //window: launcher
            item: power
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
        }

        content: ColumnLayout {
            Ctrls.MenuItem { Layout.fillWidth: true; text: "Shutdown"; onClicked: () => Services.Power.shutdown(); icon.name: "system-shutdown-symbolic"}
            Ctrls.MenuItem { Layout.fillWidth: true; text: "Hibernate"; onClicked: () => Services.Power.hibernate(); icon.name: "system-shutdown-symbolic"}
            Ctrls.MenuItem { Layout.fillWidth: true; text: "Restart"; onClicked: () => Services.Power.restart(); icon.name: "system-reboot-symbolic"}
            Ctrls.MenuItem { Layout.fillWidth: true; text: "Sleep"; onClicked: () => Services.Power.sleep(); icon.name: "system-suspend-symbolic"}
        }
    }
}
