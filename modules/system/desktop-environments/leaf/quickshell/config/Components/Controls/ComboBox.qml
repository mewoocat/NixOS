import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import qs as Root

T.ComboBox {
    id: control

    //defines the padding of the contentItem relative to the edge of the control
    padding: 4
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

    property color backgroundColor: control.hovered ? Root.State.colors.primary : "transparent"
    property color color: control.hovered ? Root.State.colors.on_primary : Root.State.colors.on_surface
    property bool isMutliColorIcon: false
    property int radius: background.implicitHeight

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    delegate: Text { text: "hi" }

    background: Rectangle {
        id: bg
        implicitWidth: 36
        implicitHeight: 18
        color: control.backgroundColor
        radius: control.radius
    }

    contentItem: Text {
        text: "stuff"
    }

    popup: Popup {
        width: 100
        height: 400
        contentItem: Text { text: "popup content" }
        background: Rectangle {
            color: "#33000000"
        }
        popupType: Popup.Native //Popup.Window
        enter: Transition {
            NumberAnimation { property: "height"; from: 1; to: 400 }
        }
        exit: Transition {
            NumberAnimation { property: "height"; from: 400; to: 1 }
        }
    }

    indicator: Rectangle {
        width: 5
        height: 5
        color: "green"
    }
}
