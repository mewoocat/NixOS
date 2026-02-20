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
        id: background
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: 60 // control.contentItem.implicitHeight + control.padding // TODO: might want to force this to be static?
        color: control.hovered ? Qt.darker(Root.State.colors.surface, 1.4) : Qt.lighter(Root.State.colors.surface, 1.4)
        radius: 8
        border.width: 1
        border.color: control.hovered ? Qt.darker(Root.State.colors.surface, 1.4) : Qt.lighter(Root.State.colors.surface, 1.4)

        property int skeuo: 2
        property int blur: 6
        property int spread: 2

        RectangularShadow {
            visible: true
            implicitWidth: parent.implicitWidth + parent.skeuo
            implicitHeight: parent.implicitHeight + parent.skeuo
            y: -parent.skeuo
            /*
            x: -offset.x
            y: 0
            offset.x: parent.skeuo
            offset.y: -parent.skeuo
            */
            radius: parent.radius
            antialiasing: false
            blur: parent.blur
            spread: parent.spread
            z: -1 // show behind parent
            //color: Qt.alpha(Root.State.colors.surface, 0.4)
            color: control.hovered ? Qt.darker(Root.State.colors.surface, 4) : Qt.lighter(Root.State.colors.surface, 2)
            //color: "green"
        }

        RectangularShadow {
            visible: true
            implicitWidth: parent.implicitWidth + (parent.skeuo * 2)
            implicitHeight: parent.implicitHeight + (parent.skeuo * 2)
            antialiasing: false
            y: -parent.skeuo
            x: -parent.skeuo
            radius: parent.radius
            blur: parent.blur
            spread: parent.spread
            z: -2
            //color: Qt.alpha(Root.State.colors.surface, 0.4)
            color: control.hovered ? Qt.darker(Root.State.colors.surface, 4) : Qt.lighter(Root.State.colors.surface, 1.6)
            //color: "blue"
        }

        RectangularShadow {
            visible: true
            implicitWidth: parent.implicitWidth + parent.skeuo + 1
            implicitHeight: parent.implicitHeight + parent.skeuo + 1
            x: -parent.skeuo -2
            y: 2
            /*
            x: 0
            y: -offset.y 
            offset.x: -parent.skeuo
            offset.y: parent.skeuo
            */
            radius: parent.radius
            blur: parent.blur
            spread: parent.spread
            z: -1 // show behind parent
            color: control.hovered ? Qt.lighter(Root.State.colors.surface, 1.6) : Qt.darker(Root.State.colors.surface, 2)
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
    contentItem: IconLabel {
        id: iconLabel
        icon.name: control.icon.name
        icon.color: Root.State.colors.on_surface
        text: control.text
        color: Root.State.colors.on_surface
    }
}
