import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import QtQuick.Controls.impl
import QtQuick.Templates as T
import Quickshell

import qs as Root

T.MenuItem {
    id: control
    
    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: 6
    leftPadding: padding //Math.max(padding, background.height / 2)
    rightPadding: padding //Math.max(padding, background.height / 2)
    topPadding: padding
    bottomPadding: padding

    property color backgroundColor: control.hovered || control.highlighted ? Root.State.colors.primary : "transparent"
    property color color: control.hovered || control.highlighted ? Root.State.colors.on_primary : Root.State.colors.on_surface
    property bool isMutliColorIcon: false
    property int radius: background.implicitHeight
    property bool hasChildren: false
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
        implicitWidth: 48//control.contentItem.implicitWidth + control.padding
        implicitHeight: 28//control.contentItem.implicitHeight + control.padding
        color: control.backgroundColor
        radius: control.radius
    }

    spacing: 4
    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: control.color
    //implicitTextPadding: 40 // I don't think this works unless the menu property is set

    // The geometry of the contentItem is determined by the padding
    // IconLabel source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickiconlabel_p.h
    // Might want to look into IconImage (from the impl namespace, not qs) as well
    contentItem: IconLabel {
        alignment: Qt.AlignLeft
        id: iconLabel
        icon.name: control.icon.name
        icon.color: control.isMutliColorIcon ? "transparent" : control.icon.color
        icon.width: control.icon.width
        icon.height: control.icon.height
        text: control.text
        spacing: control.spacing
        font.pointSize: control.font.pointSize
        font.family: control.font.family
        color: control.color
        // WARNING: I don't think the textPadding is properly getting set since there is no menu defined for this MenuItem
        //leftPadding: control.textPadding
        leftPadding: control.checkable || control.hasChildren ? control.padding + Math.max(control.indicator.width, control.arrow.width) : control.padding
        // Icons generally seem to have a bit of padding built in, if text is included, add more padding to balance it out
        rightPadding: control.text != "" && control.icon.name != "" ? 8 : 6
    }
    
    // The sub-menu arrow item for indicating a sub menu
    arrow: Rectangle {
        visible: control.hasChildren
        color: "transparent"
        x: control.leftPadding
        y: control.topPadding
        width: height//visible ? height : 0
        height: control.availableHeight
        // ColorImage source: https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrolsimpl/qquickcolorimage_p.h
        ColorImage {
            anchors.centerIn: parent
            height: 16
            width: 16
            source: Quickshell.iconPath("arrow-left-symbolic")
            color: control.color
        }
    }

    // Used for check boxes
    indicator: Rectangle {
        color: "transparent"
        x: control.leftPadding
        y: control.topPadding
        width: visible ? height : 0
        height: control.availableHeight
        visible: control.checkable

        Rectangle {
            anchors.centerIn: parent
            radius: 4
            border.width: 1
            border.color: control.color
            color: "transparent"
            width: height
            height: 18
            
            Rectangle {
                visible: control.checked
                anchors.centerIn: parent
                color: control.color
                width: height
                height: parent.height - (parent.border.width * 2) - 6
                radius: 1
            }
        }
    }
}
