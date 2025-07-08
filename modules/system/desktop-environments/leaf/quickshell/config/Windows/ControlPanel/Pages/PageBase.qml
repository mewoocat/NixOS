
import Quickshell
import QtQuick
import QtQuick.Layouts
import '../../../Modules/Common/' as Common
import '../../../' as Root

// Need wrapper item since we want to anchor the ColumnLayout to the top of the SwipeView area but 
// it doesn't like anchors being set on root item in a SwipeView
Item {
    id: root
    required property string pageName
    required property Item content
    Rectangle {
        // Anchor the column in order to set it's width and place it at top
        anchors.margins: 16
        anchors.fill: parent
        color: "transparent"

        // Header
        RowLayout {
            id: header
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left

            // Back button
            Common.NormalButton {
                text: "Back"
                leftClick: () => Root.State.controlPanelPage = 0
            } 

            // Name
            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                color: palette.text
                font.bold: true
                text: root.pageName
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            children: [ root.content ]
            color: "#2200ff00"
        }
        
    }
}
