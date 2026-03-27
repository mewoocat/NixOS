import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
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
    property real inset: 0
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    implicitWidth: background.implicitWidth + leftInset + rightInset
    implicitHeight: background.implicitHeight + bottomInset + topInset

    background: MouseArea {
        id: mouseArea
        hoverEnabled: true
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: control.contentItem.implicitHeight + control.padding

        Shape {
            id: shape
            //visible: mouseArea.containsMouse
            implicitWidth: parent.implicitWidth
            implicitHeight: parent.implicitHeight

            ShapePath {
                strokeColor: "red"
                strokeWidth: 0
                fillGradient: RadialGradient {
                    centerRadius: 20//shape.implicitHeight
                    focalRadius: 6
                    centerX: mouseArea.mouseX - control.padding
                    centerY: mouseArea.mouseY - control.padding
                    focalX: centerX; focalY: centerY
                    GradientStop { position: 0; color: Root.State.colors.primary }
                    GradientStop { position: 1; color: "#33222222" }
                }
                startX: 0
                startY: 0
                PathLine {x: shape.width; y: 0}
                PathLine {x: shape.width; y: shape.height}
                PathLine {x: 0; y: shape.height}
                PathLine {x: 0; y: 0}
            }
        }

        Rectangle {
            id: maskBox
            color: Root.State.colors.primary
            implicitWidth: control.contentItem.implicitWidth + control.padding
            implicitHeight: 28 // control.contentItem.implicitHeight + control.padding // TODO: might want to force this to be static?
            x: 4
            y: 4
        }

        OpacityMask {
            anchors.fill: shape
            source: shape
            maskSource: maskBox
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
        icon.color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
        text: control.text
        color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
    }
}
