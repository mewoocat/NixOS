import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

T.Slider {
    id: control

    hoverEnabled: true

    padding: 4
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    property real inset: 0
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: Root.State.colors.surface_container_highest
    property color textColor: control.hovered || control.pressed ? Root.State.colors.on_primary : "transparent"
    property int handleHeight: 16
    property int handleWidth: 24

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: 100 + control.padding
        implicitHeight: control.handleHeight + control.padding
        color: control.backgroundColor
        radius: implicitHeight
    }

    handle: Rectangle {
        radius: implicitHeight
        // From: https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-slider
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.handleWidth
        implicitHeight: control.handleHeight
        color: (control.hovered || control.pressed) ? Root.State.colors.primary : Root.State.colors.on_surface
        Text {
            anchors.centerIn: parent
            font.pointSize: 6
            color: control.textColor
            text: Math.round(control.visualPosition.toFixed(2) * 100) + '%'
        }
    }
}
