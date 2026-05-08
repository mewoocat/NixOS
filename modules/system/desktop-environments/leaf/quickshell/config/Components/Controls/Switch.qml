import QtQuick
import QtQuick.Templates as T

import qs as Root

T.Switch {
    id: control

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                            implicitIndicatorHeight + topPadding + bottomPadding)

    //defines the padding of the contentItem relative to the edge of the control
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    property int handlePadding: 2

    // NOTE: For some reason, if the indicator itself is dragged, it causes stuttering.  Thats why the indicator's child
    // is dragged instead and the "background" is the indicator itself
    indicator: Rectangle {
        implicitWidth: 52
        implicitHeight: 26
        color: control.checked ? "green" : Root.State.colors.surface_container_high
        Behavior on color { // NOTE: This is mainly done to prevent a flicker in the case that the control checked state changes quickly
            ColorAnimation { duration: 150 }
        }
        radius: height
        Rectangle {
            x: Math.max( // Value cannot be less than the handle padding
                control.handlePadding,
                Math.min( // Value cannot be greater than the further position minus the hanle padding
                    (control.visualPosition * (parent.width - width)) + control.handlePadding,
                    parent.width - width - control.handlePadding
                )
            )
            y: control.handlePadding
            Behavior on x { // NOTE: This also prevents a flicker that occurs when changing the switch state rapidly
                SmoothedAnimation { duration: 150 }
            }
            implicitWidth: 26 - control.handlePadding * 2
            implicitHeight: 26 - control.handlePadding * 2
            radius: height
        }
    }
    background: null
    contentItem: null
}
