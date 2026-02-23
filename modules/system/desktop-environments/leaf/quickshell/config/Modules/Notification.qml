pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Modules.Leaf as Leaf
import qs as Root

Leaf.ListItemExpandable {
    id: root
    required property var data // Essentially a Quickshell.Services.Notification as js object
    listView: listView
    mainDelegate: ColumnLayout {
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 0

        RowLayout {
            id: row
            spacing: 0
            // App icon
            IconImage {
                id: appIcon
                implicitSize: 16
                source: {
                    let name = root.data.appIcon
                    if (name === "") { name = root.data.appName.toLowerCase() }
                    Quickshell.iconPath(name, "dialog-question")
                }
            }
            // App name
            Text {
                color: Root.State.colors.on_surface
                font.pointSize: 8
                text: root.data.appName
            }
            // Spacer to push close button to right
            Rectangle {Layout.fillWidth: true;}

            Leaf.Button {
                text: "Expand"
                onClicked: root.expanded = !root.expanded
            }

            // Close button
            Leaf.NormalButton {
                implicitHeight: 32
                iconName: 'gtk-close'
                leftClick: root.data.dismiss
            }
        }
        RowLayout {
            //Layout.alignment: Qt.AlignTop
            spacing: 0
            IconImage {
                //Layout.alignment: Qt.AlignTop
                visible: root.data.image != ""
                Layout.margins: 4
                implicitSize: 40
                source: root.data.image
            }
            ColumnLayout {
                // Summary
                Text {
                    Layout.fillWidth: true
                    text: root.data.summary
                    elide: Text.ElideRight // Truncate with ... on the right
                    color: Root.State.colors.on_surface
                }

                // Body
                Text {
                    Layout.fillWidth: true
                    text: root.data.body
                    elide: Text.ElideRight // Truncate with ... on the right
                    font.pointSize: 8
                    color: Root.State.colors.on_surface
                    wrapMode: Text.Wrap
                }
            }
        }
    }
    subDelegate: ColumnLayout {
        Text { text: "more stuff"}
    }
}
