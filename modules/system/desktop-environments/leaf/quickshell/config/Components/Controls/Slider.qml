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

    // WARNING: Setting the inset to anything but 0 results in odd behavior
    property real inset: 0
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: Root.State.colors.surface_container_highest
    property color textColor: control.hovered || control.pressed ? Root.State.colors.on_primary : "transparent"
    property int handleHeight: 1//control.horizontal ? 4 : 8
    property int handleWidth: 1//control.horizontal ? 8 : 4
    property int defaultBgWidth: 100
    property int defaultBgHeight: 24
    property real handleWidthScale: 1.3

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)

    // Background will fill the entire width and height of the control unless an explicit size has been given for it or inset is set
    background: Rectangle {
        id: bg
        implicitWidth: control.horizontal
            ? defaultBgWidth
            : defaultBgHeight
        implicitHeight: control.horizontal
            ? defaultBgHeight
            : defaultBgWidth
        color: control.backgroundColor
        radius: control.horizontal
            ? height / 2
            : implicitWidth
        Rectangle {
            implicitHeight: control.horizontal
                ? parent.height
                : control.handleHeight + control.handle.y + control.padding
            implicitWidth: control.horizontal
                ? control.handle.x + control.handle.width + control.padding//control.handleWidth + control.handle.x + control.padding  //(control.visualPosition * parent.width) + control.handleWidth
                : parent.width
            //implicitWidth: (control.padding - control.inset) >  ? 
            color: Root.State.colors.primary_container
            radius: parent.radius
        }
    }

    handle: Rectangle {
        radius: implicitHeight
        // From: https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-slider
        x: control.horizontal
            ? control.leftPadding + control.visualPosition * (control.availableWidth - width)
            : control.topPadding + (control.availableWidth / 2) - (width / 2)
        y: control.horizontal
            ? control.topPadding + (control.availableHeight / 2) - (height / 2)
            : control.leftPadding + control.visualPosition * (control.availableHeight - height)
        implicitWidth: height * control.handleWidthScale
        implicitHeight: control.height - control.topPadding - control.bottomPadding // Height is remaining height after subtracting
        color: (control.hovered || control.pressed) ? Root.State.colors.primary : Root.State.colors.on_surface
        Text {
            anchors.centerIn: parent
            font.pointSize: 6
            color: control.textColor
            text: Math.round(control.visualPosition.toFixed(2) * 100) + '%'
        }
    }
}
