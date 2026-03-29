import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services as Services
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls

Shared.PanelButton {
    id: root

    onClicked: () => userPopup.visible = true

    Shared.PopupWindow {
        id: userPopup

        anchor {
            item: root
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
        }

        content: ColumnLayout {
            Text { color: palette.text; text: Services.User.username }
            Ctrls.MenuItem { text: "User Settings"; onClicked: () => {}; icon.name: "application-menu-symbolic"}
            Ctrls.MenuItem { text: "Logout"; onClicked: () => {}; icon.name: "go-previous-symbolic"}
        }
    }

    padding: 8
    
    // Needs to be a perfect square or else it won't look right
    contentItem: Item {
        ClippingWrapperRectangle {
            color: "transparent"
            anchors.centerIn: parent
            radius: root.availableWidth / 2
            IconImage {
                implicitSize: root.availableWidth
                source: Services.User.pfpPath
            }
        }
    }
}
