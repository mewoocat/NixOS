pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.Modules.Leaf as Leaf
import qs as Root

Leaf.ListItemExpandable {
    id: root
    required property Notification notifData

    // Ensure this qs notification object can't be destroyed until unlocked
    // Needed since calling dismiss for the qs notification destroys it, but we want to play an
    // animation when dismissed.  Need to keep the object around long enough for that animation
    // to play.  Otherwise quickshell seems to crash.
    // Then, whenever this object is destroyed, so will the qs notification object.
    RetainableLock {
      object: root.notifData
      locked: true
    }

    property int maxBodyLines: 4
    signal closed()
    maxCollapsedHeight: 120 
    expansionAnimationSpeed: 350
    // Seems "View" is usually the first action ... invoke it if clicked anywhere within the notification
    onClicked: {
        const firstAction = notifData.actions[0]?.invoke
        if (firstAction) { firstAction() }
        else { console.log(`No action for notification`) }
    }
    backgroundColor: root.interacted ? Root.State.colors.surface_container_highest : Root.State.colors.surface
    //mainColor: Root.State.colors.surface
    //subColor: Root.State.colors.surface

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
                        let name = root.notifData.appIcon
                        if (name === "") { name = root.notifData.appName.toLowerCase() }
                        Quickshell.iconPath(name, "dialog-question")
                    }
                }
                // App name
                Text {
                    color: Root.State.colors.on_surface
                    font.pointSize: 8
                    text: root.notifData.appName
                }
            }
            // Spacer to push close button to right
            Item {Layout.fillWidth: true;}

            Leaf.Button {
                implicitHeight: 24
                visible: root.notifData.actions?.length > 0 || ghostBody.lineCount > root.maxBodyLines
                text: "Expand"
                font.pointSize: 10
                onClicked: root.expanded = !root.expanded
            }

            Leaf.Button {
                implicitWidth: 32
                implicitHeight: 24
                icon.name: 'gtk-close'
                onClicked: () => {
                    root.notifData.dismiss()
                    root.closed()
                }
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
                visible: root.notifData.image != ""
                Layout.margins: 4
                implicitSize: 40
                source: root.notifData.image
            }
            ColumnLayout {
                // Summary
                Text {
                    Layout.fillWidth: true
                    text: root.notifData.summary
                    elide: Text.ElideRight // Truncate with ... on the right
                    color: Root.State.colors.on_surface
                }

                Item {
                    Layout.fillWidth: true
                    implicitHeight: ghostBody.implicitHeight
                    component Body: Text {
                        anchors.fill: parent
                        text: root.notifData.body
                        elide: Text.ElideRight // Truncate with ... on the right
                        font.pointSize: 8
                        color: Root.State.colors.on_surface_variant
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
    subDelegate: FlexboxLayout {
        // TODO: For some reason enabling wrap causes the height of the FlexboxLayout to be increased for each child
        // even if multiple children are layed out horizontally.
        //wrap: FlexboxLayout.wrapMode
        direction: FlexboxLayout.Row
        Repeater {
            model: root.notifData.actions
            delegate: Leaf.Button {
                required property var modelData
                text: modelData.text
                onClicked: modelData.invoke()
            }
        }
    }
}
