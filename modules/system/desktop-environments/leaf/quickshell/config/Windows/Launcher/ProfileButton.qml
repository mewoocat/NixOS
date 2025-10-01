import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Services as Services
import qs.Modules.Common as Common

ProfilePictureItem {
    id: user
    onClicked: () => {
        console.log("click")
        userPopup.visible = true
    }
    Common.PopupWindow {
        id: userPopup

        anchor {
            //window: launcher
            item: user
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
        }

        content: ColumnLayout {
            Text { color: palette.text; text: Services.User.username }
            Common.PopupMenuItem { text: "User Settings"; action: () => {}; iconName: "application-menu-symbolic"}
            Common.PopupMenuItem { text: "Logout"; action: () => {}; iconName: "go-previous-symbolic"}
        }
    }
}
