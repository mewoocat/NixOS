pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.Modules.Common as Common

Common.ScrollableItem {
    id: mouseArea
    required property DesktopEntry modelData
    property alias app: mouseArea.modelData
    property var launcher: null
    bgColorHighlight: palette.accent
    contentMargin: 4
    onClicked: launcher.launchApp(app)
    content: RowLayout {
        anchors.fill: parent
        IconImage {
            Layout.leftMargin: 4
            id: icon
            implicitSize: 32
            source: Quickshell.iconPath(mouseArea.app.icon)
        }
        ColumnLayout {
            spacing: 0
            Text{
                Layout.fillWidth: true
                leftPadding: 8
                rightPadding: 8
                elide: Text.ElideRight // Truncate with ... on the right
                text: mouseArea.app.name
                color: mouseArea.containsMouse || mouseArea.focus ? palette.highlightedText : palette.text
            }
            Text{
                Layout.fillWidth: true
                leftPadding: 8
                rightPadding: 8
                elide: Text.ElideRight // Truncate with ... on the right
                text: {
                    let description = ""
                    if (mouseArea.app.genericName !== "" && mouseArea.app.comment !== "") {
                        return mouseArea.app.genericName + " | " + mouseArea.app.comment
                    }
                    else if (mouseArea.app.genericName !== "") {
                        return mouseArea.app.genericName
                    }
                    else if (mouseArea.app.comment !== "") {
                        return mouseArea.app.comment
                    }
                    else {
                        return "No description"
                    }
                }
                color: mouseArea.containsMouse || mouseArea.focus ? palette.highlightedText : palette.placeholderText
                font.pointSize: 8
            }
        }
        Common.NormalButton {
            Layout.alignment: Qt.AlignRight
            iconName: "view-more"
            leftClick: mouseArea.toggleExpand
        }
    }
    subContent: Text {
        color: "red"
        text: "test test test"
    }
}
