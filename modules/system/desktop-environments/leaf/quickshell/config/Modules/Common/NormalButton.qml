
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

MouseArea {
    id: mouseArea
    
    // On mouse click functions
    property var leftClick: null
    property var rightClick: null
    property var middleClick: null
    property var action // !! Deprecated

    property Item iconItem: icon

    property string iconName: ""
    property string iconSource: "" // Source url of an icon to use
    property string text: ""
    property bool isClickable: true
    implicitWidth: box.width
    //implicitHeight: parent.height
    implicitHeight: 40
    enabled: isClickable // Whether mouse events are accepted
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (event) => {
        switch(event.button) {
            case Qt.LeftButton:
                if (leftClick != null){ leftClick() }
                break
            case Qt.RightButton:
                if (rightClick != null){ rightClick() }
                break
            case Qt.MiddleButton:
                if (MiddleButton != null){ middleClick() }
                break
            default:
                console.log("button problem")
        }
    }

    Rectangle {
        id: box
        anchors.centerIn: parent
        //implicitWidth: iconName != "" ? icon.width + 16 : text.width + 16
        implicitWidth: row.width
        implicitHeight: parent.height - 12
        radius: 24
        color: mouseArea.containsMouse ? palette.highlight : "#00000000"

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
                implicitSize: mouseArea.height / 2
                source: mouseArea.iconName == "" ? mouseArea.iconSource : Quickshell.iconPath(mouseArea.iconName)
                /*
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1
                    colorizationColor: "#ff0000"
                }
                */
                // Animate changes to the rotation property
                Behavior on rotation {
                    PropertyAnimation { property: "rotation"; duration: 300 }
                }
            }
            Text {
                id: text
                //Rectangle { anchors.fill: parent; color: "#990000ff" }
                //Layout.fillWidth: true
                visible: mouseArea.text != ""
                Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: mouseArea.icon === "" ? 8 : 0
                Layout.rightMargin: 8
                text: mouseArea.text
                font.pointSize: 12
                color: palette.text
            }
        }
   }
}
