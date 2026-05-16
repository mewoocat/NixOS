import QtQuick
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import QtQuick.Shapes
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

// Custom button based off logic template.  This is the recommended way to create a custom
// style.  Should probably follow this pattern for the rest of the controls
T.TextField {
    id: control

    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: 8
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    property color backgroundColor: Root.State.colors.surface_container
    color: Root.State.colors.on_surface
    property bool isMultiColorIcon: false
    property int radius: background.height / 2
    // Defines the padding of the background
    property real inset: 2
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset

    background: Rectangle {
        id: bg
        implicitWidth: 128
        implicitHeight: control.font.pointSize + control.topPadding + control.bottomPadding
        color: control.backgroundColor
        radius: control.radius
    }

    
}
