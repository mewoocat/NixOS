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
    bgColorHighlight: palette.base
    contentMargin: 4
    onClicked: launcher.launchApp(app)
    content: RowLayout {
        anchors.fill: parent
        // Warning: this icon lookup is expensive on the startup time
        IconImage {
            Layout.leftMargin: 4
            id: icon
            implicitSize: 32
            source: Quickshell.iconPath(mouseArea.app.icon, "dialog-question")
        }
        ColumnLayout {
            spacing: 0
            Text{
                Layout.fillWidth: true
                leftPadding: 8
                rightPadding: 8
                elide: Text.ElideRight // Truncate with ... on the right
                text: mouseArea.app.name
                //color: mouseArea.containsMouse || mouseArea.focus ? palette.highlightedText : palette.text
                color: palette.text
            }
            Text{
                Layout.fillWidth: true
                leftPadding: 8
                rightPadding: 8
                elide: Text.ElideRight // Truncate with ... on the right
                text: {
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
                //color: mouseArea.containsMouse || mouseArea.focus || mouseArea.expanded ? palette.highlightedText : palette.placeholderText
                color: palette.text
                font.pointSize: 8
            }
        }
        // Used to enforce the height of the show more button when it's invisible
        Item { implicitHeight: showMoreBtn.buttonHeight }
        Common.NormalButton {
            id: showMoreBtn
            visible: mouseArea.interacted && mouseArea.app.actions.length > 0
            Layout.alignment: Qt.AlignRight
            iconName: "view-more"
            leftClick: () => mouseArea.expanded = !mouseArea.expanded
            defaultIconColor: palette.highlightedText
            activeIconColor: palette.text
            recolorIcon: true
        }
    }
    subContent: ColumnLayout {
        Repeater {
            model: mouseArea.app.actions
            delegate: Common.NormalButton {
                required property DesktopAction modelData
                text: modelData.name
                leftClick: modelData.execute
                //textColor: mouseArea.interacted | mouseArea.expanded ? palette.highlightedText : palette.placeholderText
                textColor: palette.text
                recolorIcon: true
            }
        }
    }
}
