import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

MouseArea {
    id: mouseArea
    
    // On mouse click functions
    property var leftClick
    property var rightClick
    property var middleClick
    property var action // !! Deprecated

    property string iconName: ""
    property string iconSource: "" // Source url of an icon to use
    property string text: ""
    property bool isClickable: true
    implicitWidth: box.width
    //implicitHeight: parent.height
    implicitHeight: 40
    enabled: isClickable // Whether mouse events are accepted
    hoverEnabled: true
    onClicked: (event) => {
        console.log("what")
        if (event.button === Qt.LeftButton && leftClick != null) {
            rightClick()
            //leftClick()
        }
        else if (event.button === Qt.RightButton && rightClick != null) {
            rightClick()
        }
        else if (event.button === Qt.MiddleButton != null) {
            middleClick()
        }
    }
    Rectangle {
        id: box
        anchors.centerIn: parent
        //implicitWidth: iconName != "" ? icon.width + 16 : text.width + 16
        implicitWidth: row.width
        implicitHeight: 28
        radius: 24
        color: mouseArea.containsMouse ? "grey" : "#00000000"

        RowLayout {
            id: row
            implicitWidth: text.width + icon.width + 8 + 8 + 4
            height: parent.height
            spacing: 4
            IconImage {
                //Rectangle { anchors.fill: parent; color: "#9900ff00" }
                Layout.leftMargin: 8
                Layout.rightMargin: mouseArea.text === "" ? 8 : 0
                id: icon
                visible: mouseArea.iconName != "" || mouseArea.iconSource != ""
                implicitSize: 20
                source: mouseArea.iconName == "" ? mouseArea.iconSource : Quickshell.iconPath(mouseArea.iconName)
                // Recoloring icon
                /*
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1
                    colorizationColor: "#ff0000"
                }
                */
            }
            Text {
                id: text
                //Rectangle { anchors.fill: parent; color: "#990000ff" }
                //Layout.fillWidth: true
                visible: mouseArea.text != ""
                Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: mouseArea.icon === "" ? 8 : 0
                Layout.rightMargin: 8
                color: "#ffffff"
                text: mouseArea.text
                font.pointSize: 12
            }
        }
   }
}
