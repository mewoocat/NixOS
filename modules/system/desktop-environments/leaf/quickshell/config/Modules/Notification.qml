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
    property int maxBodyLines: 4
    maxCollapsedHeight: 120 
    expansionAnimationSpeed: 350
    onClicked: console.log(JSON.stringify(data.actions, null, 4))
    mainDelegate: Rectangle {
        id: main
        property bool moreBodyText: ghostBody.implicitHeight > body.implicitHeight
        implicitWidth: parent.implicitWidth
        //implicitHeight: root.expanded ? header.implicitHeight + content.implicitHeight : Math.min(header.implicitHeight + content.implicitHeight, root.maxCollapsedHeight - root.padding * 2) // Need to subtract out the padding since it affects the overall height of the item
        implicitHeight: header.implicitHeight + content.implicitHeight
        color: "transparent"

        RowLayout {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0

            // App icon
            RowLayout {
                IconImage {
                    id: appIcon
                    implicitSize: 18
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
            }
            // Spacer to push close button to right
            Item {Layout.fillWidth: true;}

            Leaf.Button {
                //visible: root.data.actions?.length > 0 || ghostBody.lineCount > root.maxBodyLines
                text: "Expand"
                onClicked: root.expanded = !root.expanded
            }

            Leaf.Button {
                implicitWidth: 32
                icon.name: 'gtk-close'
                onClicked: () => root.data.dismiss()
            }
        }
        RowLayout {
            id: content
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 0
            IconImage {
                Layout.alignment: Qt.AlignTop
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

                Item {
                    Layout.fillWidth: true
                    implicitHeight: ghostBody.implicitHeight
                    component Body: Text {
                        anchors.fill: parent
                        text: root.data.body
                        elide: Text.ElideRight // Truncate with ... on the right
                        font.pointSize: 8
                        color: Root.State.colors.on_surface
                        wrapMode: Text.Wrap
                        maximumLineCount: root.expanded ? undefined : root.maxBodyLines
                        Behavior on maximumLineCount { PropertyAnimation { duration: root.expansionAnimationSpeed } }
                    }
                    // Actual body which is visible
                    Body {
                        id: body
                    }
                    // Need another instance to force the height to be static while still being able to use the maximumLineCount
                    // to truncate text when collapsed.
                    Body {
                        id: ghostBody
                        opacity: 0
                        maximumLineCount: undefined
                    }
                }
            }
        }
    }
    subDelegate: ColumnLayout {
        Text { text: "actions"}
        Repeater {
            model: root.data.actions
            delegate: Leaf.Button {
                required property var modelData
                text: modelData.text
                onClicked: modelData.invoke
            }
        }
    }
}
