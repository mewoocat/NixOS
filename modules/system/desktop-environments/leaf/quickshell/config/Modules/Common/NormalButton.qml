
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

MouseArea {
    id: root
    
    // Mouse clicks
    property bool isClickable: true
    property var leftClick: null
    property var rightClick: null
    property var middleClick: null
    property var action // !! Deprecated

    // Content
    property Item iconItem: icon
    property string iconName: ""
    property string iconSource: "" // Source url of an icon to use
    property string text: ""
    property bool recolorIcon: false

    // Size and Margins
    property int buttonHeight: 40 // Default height
    property int internalHeight: implicitHeight - topInternalMargin - bottomInternalMargin
    property int defaultInternalMargin: 4
    property int leftInternalMargin: defaultInternalMargin
    property int rightInternalMargin: defaultInternalMargin
    property int topInternalMargin: defaultInternalMargin
    property int bottomInternalMargin: defaultInternalMargin
    property int iconSize: implicitHeight / 2
    implicitWidth: box.width + leftInternalMargin + rightInternalMargin
    implicitHeight: buttonHeight

    //implicitHeight: box.height + internalMargin
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
        implicitHeight: root.internalHeight
        radius: 24
        color: root.containsMouse ? palette.highlight : "#00000000"

        RowLayout {
            id: row
            //implicitWidth: text.width + icon.width + 8 + 8 + 4
            height: parent.height
            spacing: 4
            IconImage {
                //Rectangle { anchors.fill: parent; color: "#9900ff00" }
                Layout.leftMargin: 8
                Layout.rightMargin: root.text === "" ? 8 : 0
                id: icon
                visible: root.iconName != "" || root.iconSource != ""
                implicitSize: root.iconSize
                source: root.iconName == "" ? root.iconSource : Quickshell.iconPath(root.iconName)

                // Icon recoloring
                layer.enabled: false
                //layer.enabled: root.recolorIcon
                layer.effect: MultiEffect {
                    colorization: 1
                    colorizationColor: root.containsMouse ? palette.highlightedText : palette.text
                }

                // Animate changes to the rotation property
                Behavior on rotation {
                    PropertyAnimation { property: "rotation"; duration: 300 }
                }
            }
            Text {
                id: text
                //Rectangle { anchors.fill: parent; color: "#990000ff" }
                //Layout.fillWidth: true
                visible: root.text != ""
                Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: root.iconName === "" ? 8 : 0
                Layout.rightMargin: 8
                text: root.text
                font.pointSize: 12
                //color: root.containsMouse ? palette.highlightedText : palette.text
                color: palette.text
            }
        }
   }
}
