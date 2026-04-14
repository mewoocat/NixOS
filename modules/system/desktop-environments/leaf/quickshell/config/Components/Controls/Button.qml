import QtQuick
import Quickshell.Widgets
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
    padding: 4
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    property color backgroundColor: control.hovered ? Root.State.colors.primary : "transparent"
    property color color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
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
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: 36//control.contentItem.implicitWidth + control.padding
        implicitHeight: 18//control.contentItem.implicitHeight + control.padding
        color: control.backgroundColor
        radius: control.radius
    }

    spacing: 4
    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: control.color

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: IconLabel {
        id: iconLabel
        icon.name: control.icon.name
        icon.color: control.isMultiColorIcon ? "transparent" : control.icon.color
        icon.width: control.icon.width
        icon.height: control.icon.height
        text: control.text
        spacing: control.spacing
        font.pointSize: control.font.pointSize
        font.family: control.font.family
        color: control.color
        leftPadding: 6
        // Icons generally seem to have a bit of padding built in, if text is included, add more padding to balance it out
        rightPadding: control.text != "" && control.icon.name != "" ? 8 : 6
        Behavior on rotation {
            PropertyAnimation { property: "rotation"; duration: 300 }
        }
    }
}
