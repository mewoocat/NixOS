pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../../Services/" as Services
import "../../../Modules/Common" as Common
import "../../../" as Root
import "../Components"

PageBase {
    id: root
    pageName: "Display"
    property int maxWidth: 700
    property int minWidth: 300
    color: "#440000ff"
    content: ColumnLayout {
        id: thing

        // !!! For some reason, using the implicitWidth to set the width of this ColumnLayout to
        // parent width doesn't match.  Using anchors seems to work fine though.
        // Also note that this issue doesn't seem to occur unless a nested child sets it's height
        // using implicitHeight based of a parent height.
        // Nevermind, its still an issue
        implicitWidth: parent.parent.parent.width

        // Note that the scrollview is a distant parent of this columnlayout
        Button {
            text: "stupid"
            onClicked: {
                console.log(`root width = ${root.width}`)
                console.log(`parent width = ${thing.parent.width}`)
                console.log(`parent = ${thing.parent.parent.parent}`)
            }
        }
        
        //anchors.left: parent.left
        //anchors.right: parent.right

        spacing: 16
        
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 100
            color: "purple"

        }
        // Visual config
        Rectangle { 
            id: visualBox
            //Layout.maximumWidth: root.maxWidth
            //Layout.minimumWidth: root.minWidth
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            height: 100
            property int scaleFactor: 12
        }

        // Options
        OptionSection {
            name: "General"
            options: [
                SwitchOption {},
                ComboOption {},
                SliderOption {},
                SpinOption {},
                TextOption {}
            ]
        }
    }
}
