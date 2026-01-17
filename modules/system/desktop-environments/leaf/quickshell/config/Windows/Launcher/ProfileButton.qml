import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.Services as Services
import qs.Modules.Common as Common


import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.Services as Services

WrapperMouseArea {
    id: root
    required property string imgPath

    enabled: true
    hoverEnabled: true
    margin: 4

    onClicked: () => {
        console.log("click")
        userPopup.visible = true
    }

    Common.PopupWindow {
        id: userPopup

        anchor {
            item: root
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Top | Edges.Right
        }

        content: ColumnLayout {
            Text { color: palette.text; text: Services.User.username }
            Common.PopupMenuItem { text: "User Settings"; action: () => {}; iconName: "application-menu-symbolic"}
            Common.PopupMenuItem { text: "Logout"; action: () => {}; iconName: "go-previous-symbolic"}
        }
    }

    WrapperRectangle {
        margin: 4
        radius: 12
        color: root.containsMouse ? palette.highlight : palette.base
        ClippingRectangle {
            radius: 20
            implicitWidth: 32
            implicitHeight: 32
            IconImage {
                implicitSize: 32
                anchors.centerIn: parent
                source: Services.User.pfpPath
            }
        }
    }
}
