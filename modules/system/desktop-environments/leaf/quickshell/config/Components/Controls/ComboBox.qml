pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import qs as Root

T.ComboBox {
    id: control

    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    // Defines the padding of the background
    property real inset: 2
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: control.hovered ? Root.State.colors.primary : Root.State.colors.surface_container
    property color color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
    property bool isMutliColorIcon: false
    property int radius: 10 //background.implicitHeight

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)


    delegate: ItemDelegate { // Inherits from AbstractButton
        id: delegate

        required property var model
        required property int index

        text: model[control.textRole]
    }

    background: Rectangle {
        id: bg
        implicitWidth: 120
        implicitHeight: 30
        color: control.backgroundColor
        radius: control.radius
    }

    contentItem: Rectangle {
        color: "transparent"
        Text {
            anchors.centerIn: parent
            text: "stuff"
            color: control.color
        }
    }

    // WARNING!: The exit Transition a Popup doesn't seem to play unless esc is used to close
    popup: Popup {
        y: control.height + 8
        width: control.width
        height: contentItem.implicitHeight + 1 // Can't be 0 or qs will crash
        closePolicy: Popup.NoAutoClose // Doesn't seem to take effect
        background: Rectangle {
            color: Root.State.colors.surface
            radius: control.radius
        }
        contentItem: ListView {
            implicitHeight: contentHeight
            model: control.delegateModel // Provides both the model and delegate
        }
        popupType: Popup.Window
        /*
        enter: Transition {
            NumberAnimation { property: "height"; from: 1; to: 400 }
        }
        exit: Transition {
            NumberAnimation { property: "height"; from: 400; to: 1;
            }
        }
        */
    }

    indicator: Rectangle {
        width: 5
        height: 5
        color: "green"
    }
}
