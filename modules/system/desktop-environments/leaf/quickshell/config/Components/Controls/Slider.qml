import QtQuick
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
    property int defaultBgWidth: control.horizontal ? 100 : 24
    property int defaultBgHeight: control.horizontal ? 24 : 100
    property real handleWidthScale: 1.3

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    /* Causes binding loop since handle size is determined by control size but here the control size is determined by
     * the handle size
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)
    */
    implicitWidth: defaultBgWidth + leftInset + rightInset
    implicitHeight: defaultBgHeight + topInset + bottomInset

    // Background will fill the entire width and height of the control unless an explicit size has been given for it or inset is set
    background: Rectangle {
        implicitWidth: control.horizontal
            ? control.defaultBgWidth
            : control.defaultBgHeight
        implicitHeight: control.horizontal
            ? control.defaultBgHeight
            : control.defaultBgWidth
        color: control.backgroundColor
        radius: control.horizontal
            ? height / 2
            : width / 2
        Rectangle { // Highlight
            implicitHeight: control.horizontal
                ? parent.height
                : control.handle.y + control.handle.height + control.padding - control.inset
            implicitWidth: control.horizontal
                ? control.handle.x + control.handle.width + control.padding - control.inset
                : parent.width
            color: Root.State.colors.primary_container
            radius: parent.radius
        }
    }

    handle: Rectangle {
        radius: height / 2
        // From: https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-slider
        x: control.horizontal
            ? control.leftPadding + control.visualPosition * (control.availableWidth - width) + control.inset
            : control.topPadding + (control.availableWidth / 2) - (width / 2)
        y: control.horizontal
            ? control.topPadding + (control.availableHeight / 2) - (height / 2)
            : control.leftPadding + control.visualPosition * (control.availableHeight - height) + control.inset
        implicitWidth: control.horizontal
            ? height * control.handleWidthScale
            : control.availableWidth - control.inset * 2
        implicitHeight: control.horizontal
            ? control.availableHeight - control.inset * 2
            : width * control.handleWidthScale
        color: control.hovered || control.pressed
            ? Root.State.colors.primary
            : Root.State.colors.on_surface
        Text {
            anchors.centerIn: parent
            font.pointSize: 6
            color: control.textColor
            text: Math.round(control.visualPosition.toFixed(2) * 100) + '%'
        }
    }
}
