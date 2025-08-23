
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Modules.Common as Common
import qs as Root

// Need wrapper item since we want to anchor the ColumnLayout to the top of the SwipeView area but 
// it doesn't like anchors being set on root item in a SwipeView
Item {
    id: root
    required property string pageName
    required property Item content

    ColumnLayout {
        anchors.margins: 16
        id: header
        anchors.fill: parent
        spacing: 12

        // Header
        RowLayout {
            // Back button
            Common.NormalButton {
                defaultInternalMargin: 2
                buttonHeight: 32
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
            Layout.fillWidth: true
            radius: 20
            implicitHeight: 1
            color: "#777777"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            children: [ root.content ]
            //color: "#2200ff00"
            color: "transparent"
        }
    }
}
