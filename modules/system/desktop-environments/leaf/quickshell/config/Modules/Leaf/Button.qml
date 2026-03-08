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
    padding: 6
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    property color backgroundColor: control.hovered ? Root.State.colors.primary : "transparent"
    property color textColor: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
    // Defines the padding of the background
    property real inset: 2
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: control.contentItem.implicitWidth + control.padding
        implicitHeight: control.contentItem.implicitHeight + control.padding
        color: control.backgroundColor
        radius: implicitHeight
    }

    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: IconLabel {
        id: iconLabel
        icon.name: control.icon.name
        icon.color: control.icon.color
        text: control.text
        font.pointSize: control.font.pointSize
        color: textColor
        leftPadding: 2
        rightPadding: 2
    }
}
