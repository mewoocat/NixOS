
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs as Root

// Need wrapper item since we want to anchor the ColumnLayout to the top of the SwipeView area but 
// it doesn't like anchors being set on root item in a SwipeView
Item {
    id: root
    required property string pageName
    required property Item content
    property Item headerContent: Item {}

    ColumnLayout {
        id: header
        anchors.margins: 12
        anchors.fill: parent
        spacing: 4

        // Header
        RowLayout {
            // Back button
            Ctrls.Button {
                icon.name: "arrow-left-symbolic"
                onClicked: () => Root.State.controlPanelPage = 0
            } 

            // Spacer
            Item { Layout.fillWidth: true }

            // Extra optional content
            WrapperItem { children: [root.headerContent] }

            // Name
            Text {
                color: palette.text
                text: root.pageName
            }
        }

        Shared.HorizontalLine {}

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            children: [ root.content ]
            color: "transparent"
        }
    }
}
