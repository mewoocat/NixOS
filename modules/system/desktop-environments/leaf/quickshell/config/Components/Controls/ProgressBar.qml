import QtQuick
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

T.ProgressBar {
    id: control

    hoverEnabled: true

    padding: 3
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
    property color textColor: control.hovered ? Root.State.colors.on_primary : "transparent"
    property int handleHeight: 16
    property int handleWidth: 24
    property int defaultLength: 100

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitBackgroundWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitBackgroundHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: control.defaultLength + control.padding
        implicitHeight: control.handleHeight + control.padding
        color: control.backgroundColor
        radius: implicitHeight
    }

    // The real width of the progress "bar" after taking into account the clipping
    property int trueBarWidth: visualPosition * (contentItem.width - leftPadding - rightPadding)
    contentItem: Item {

        Rectangle {
            id: mask
            clip: true
            color: "#000f0fee"
            implicitWidth: control.leftPadding + control.trueBarWidth
            implicitHeight: parent.height
            Rectangle {
                radius: implicitHeight
                // From: https://doc.qt.io/qt-6/qtquickcontrols-customize.html#customizing-slider
                x: control.leftPadding
                y: control.topPadding
                implicitWidth: (control.trueBarWidth > height)
                    ? control.visualPosition * (control.contentItem.width - control.leftPadding - control.rightPadding)
                    : implicitHeight
                implicitHeight: control.contentItem.height - control.topPadding - control.bottomPadding
                color: (control.hovered) ? Root.State.colors.primary : Root.State.colors.on_surface
                Text {
                    anchors.centerIn: parent
                    font.pointSize: 6
                    color: control.textColor
                    text: Math.round(control.visualPosition.toFixed(2) * 100) + '%'
                }
            }
        }
    }
}
