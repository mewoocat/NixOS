import QtQuick
import QtQuick.Effects
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

// Custom button based off logic template.  This is the recommended way to create a custom
// style.  Should probably follow this pattern for the rest of the controls
T.Button {
    id: control

    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: inset * 2

    // Defines the padding of the background
    property real inset: 6
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    implicitWidth: background.implicitWidth + leftInset + rightInset
    implicitHeight: background.implicitHeight + bottomInset + topInset
    background: Rectangle {
        id: bg
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: 30 // control.contentItem.implicitHeight + control.padding // TODO: might want to force this to be static?
        color:  control.hovered ? Qt.darker(Root.State.colors.surface, 1.4) : Qt.lighter(Root.State.colors.surface, 1.4)
        radius: 8
        border.width: 0
        border.color: control.hovered ? Qt.lighter(Root.State.colors.surface, 1.2) : Qt.lighter(Qt.alpha(Root.State.colors.on_surface, 0.1), 0.4)

        property int skeuo: 2
        property int blur: 4
        property int spread: 2 // increasing this causes the positions to get wack
        property int animSpeed: 100
        property var easingType: Easing.OutInExpo

        property var topRightPos: QtObject {
            property int x: 0
            property int y: -(bg.skeuo * 2)
        }

        property var botLeftPos: QtObject {
            property int x: -bg.skeuo
            property int y: 0
        }

        // Highlight
        RectangularShadow {
            visible: true
            implicitWidth: bg.implicitWidth + (bg.skeuo * 2)
            implicitHeight: bg.implicitHeight + (bg.skeuo * 2)
            x: control.hovered ? bg.botLeftPos.x : bg.topRightPos.x
            y: control.hovered ? bg.botLeftPos.y : bg.topRightPos.y
            Behavior on x { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            Behavior on y { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }

            radius: bg.radius
            blur: bg.blur
            spread: bg.spread
            z: -2 // show behind parent
            color: Qt.lighter(Root.State.colors.surface, 2)
            //color: "green"
        }

        // Background
        RectangularShadow {
            visible: false
            implicitWidth: bg.implicitWidth + (bg.skeuo * 2)
            implicitHeight: bg.implicitHeight + (bg.skeuo * 2)
            antialiasing: false
            //y: -bg.skeuo
            //x: -bg.skeuo
            radius: bg.radius
            blur: bg.blur
            spread: bg.spread
            z: -2
            color: Qt.lighter(Root.State.colors.surface, 1.6)
            //color: "blue"
        }

        // Shadow
        RectangularShadow {
            visible: true
            implicitWidth: bg.implicitWidth + (bg.skeuo * 2)
            implicitHeight: bg.implicitHeight + (bg.skeuo * 2)
            x: control.hovered ? bg.topRightPos.x : bg.botLeftPos.x
            y: control.hovered ? bg.topRightPos.y : bg.botLeftPos.y
            Behavior on x { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            Behavior on y { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            radius: bg.radius
            blur: bg.blur
            spread: bg.spread
            z: -3 // show behind parent
            color: Qt.darker(Root.State.colors.surface, 4)
            //color: "red"
        }
    }
    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: "red"

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: Item {
        implicitHeight: iconLabel.implicitHeight
        implicitWidth: iconLabel.implicitWidth
        IconLabel {
            id: iconLabel
            icon.name: control.icon.name
            icon.color: Root.State.colors.on_surface
            text: control.text
            color: Root.State.colors.on_surface
            x: control.hovered ? -1 : 0
            y: control.hovered ? 1 : 0
            Behavior on x { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
            Behavior on y { PropertyAnimation { duration: bg.animSpeed; easing.type: bg.easingType} }
        }
    }
}
