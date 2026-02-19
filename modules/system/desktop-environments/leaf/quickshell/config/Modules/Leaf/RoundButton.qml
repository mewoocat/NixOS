import QtQuick
import QtQuick.Templates as T

// TODO: Should we avoid importing Quickshell if we want this to be generic?
import Quickshell.Widgets

// Custom button based off logic template.  This is the recommended way to create a custom
// style.  Should probably follow this pattern for the rest of the controls
T.RoundButton {
    contentItem: Text {
        text: "click"
    }

    background: Rectangle {
        //anchors.centerIn: parent
        //implicitWidth: root.bgSize
        //implicitHeight: root.bgSize
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
