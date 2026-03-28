import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Services as Services
import qs.Modules.Leaf as Leaf
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls

Shared.PanelButton {
    id: root
    required property string imgPath

    onClicked: () => userPopup.visible = true

    Leaf.PopupWindow {
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

    contentItem: Rectangle {
        color: "blue"
        ClippingWrapperRectangle {
            color: "green"
            radius: root.availableWidth / 2
            IconImage {
                implicitSize: root.availableWidth
                anchors.centerIn: parent
                source: Services.User.pfpPath
            }
        }
    }
}
