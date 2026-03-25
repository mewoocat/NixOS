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

    property real inset: 4
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: Root.State.colors.surface_container_highest
    property color textColor: control.hovered || control.pressed ? Root.State.colors.on_primary : "transparent"
    //property int handleHeight: control.horizontal ? 16 : 24
    //property int handleWidth: control.horizontal ? 24 : 16
    property int defaultLength: 100
    property int handleSpacing: padding - inset

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)

    // Fills the entire space of the control minus any inset, unless an explicit size
    // has been provided
    background: Rectangle {
        id: bg
        /*
        implicitWidth: control.horizontal
            ? control.defaultLength + control.leftInset + control.rightInset
            : control.handleWidth + control.leftInset + control.rightInset
        implicitHeight: control.horizontal
            ? control.handleHeight + control.topInset + control.bottomInset
            : control.defaultLength + control.topInset + control.bottomInset
        */
        color: control.backgroundColor
        radius: control.horizontal
            ? height
            : width
        Rectangle {
            implicitHeight: control.horizontal
                ? parent.height
                : control.handleHeight + control.handle.y + control.padding
            implicitWidth: control.horizontal
                ? control.handleWidth + control.handle.x + control.padding  //(control.visualPosition * parent.width) + control.handleWidth
                : parent.width
            color: control.visualPosition != 0 ? Root.State.colors.primary_container : "transparent"
            radius: parent.radius - anchors.margins
        }
    }

    handle: Rectangle {
        radius: implicitHeight
        // From: https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-slider
        x: control.horizontal
            ? control.handleSpacing + control.visualPosition * (control.availableWidth - width)
            : control.handleSpacing + control.availableWidth / 2 - width / 2
        y: control.horizontal
            ? control.handleSpacing + control.availableHeight / 2 - height / 2
            : control.handleSpacing + control.visualPosition * (control.availableHeight - height)
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
