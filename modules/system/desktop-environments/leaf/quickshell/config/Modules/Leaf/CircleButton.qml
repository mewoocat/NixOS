pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs as Root

MouseArea {
    id: root
    
    // Mouse clicks
    property bool isClickable: true
    property bool toggled: false // Override this to indicate toggled status
    signal leftClick()
    signal rightClick()

    // Content
    property Item iconItem: icon
    property string iconName: ""
    property string iconSource: "" // Source url of an icon to use
    property bool recolorIcon: true

    // Size and Margins
    property int size: 40
    property int bgSize: 32
    property int iconSize: 16

    // Style
    property color defaultIconColor: Root.State.colors.on_surface
    property color activeIconColor: Root.State.colors.on_primary
    property color defaultBgColor: "transparent"
    property color activeBgColor: Root.State.colors.primary

    // Behavior
    property bool highlighted: false
    property bool active: root.containsMouse || root.highlighted

    implicitWidth: size
    implicitHeight: size

    enabled: isClickable // Whether mouse events are accepted
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (event) => {
        switch(event.button) {
            case Qt.LeftButton:
                if (leftClick != null){ leftClick() }
                break
            case Qt.RightButton:
                if (rightClick != null){ rightClick() }
                break
            default:
                console.error("button problem")
        }
    }

    Rectangle {
        id: box
        anchors.centerIn: parent
        implicitWidth: root.bgSize
        implicitHeight: root.bgSize
        radius: root.bgSize
        color: root.active || root.toggled ? root.activeBgColor : root.defaultBgColor

        IconImage {
            id: icon
            anchors.centerIn: parent
            visible: root.iconName != "" || root.iconSource != ""
            implicitSize: root.iconSize
            source: root.iconName == "" ? root.iconSource : Quickshell.iconPath(root.iconName)

            // Icon recoloring
            layer.enabled: root.recolorIcon
            layer.effect: MultiEffect {
                colorization: 1
                colorizationColor: root.containsMouse ? root.activeIconColor : root.defaultIconColor
            }

            // Animate changes to the rotation property
            Behavior on rotation {
                PropertyAnimation { property: "rotation"; duration: 300 }
            }
        }
    }
}
