pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import QtQuick.Templates as T
import qs as Root

T.ComboBox {
    id: control

    hoverEnabled: true

    //defines the padding of the contentItem relative to the edge of the control
    padding: 4
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    // Defines the padding of the background
    property real inset: 0
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: control.hovered ? Root.State.colors.surface_container_high : Root.State.colors.surface_container
    property color color: control.hovered ? Root.State.colors.on_surface : Root.State.colors.on_surface
    property bool isMutliColorIcon: false
    property int radius: 12 //background.implicitHeight
    property int minDelegateWidth: 200

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: 120
        implicitHeight: 30
        color: control.backgroundColor
        radius: control.radius
    }

    contentItem: Rectangle {
        color: "#0000ff00"
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 4
            text: control.displayText
            color: control.color
        }
    }

    delegate: MenuItem {
        id: delegate
        hoverEnabled: control.hoverEnabled
        // Width of MenuItem should be determined by whether it's desired width, the displayed item, or the popup's width is largest
        width: Math.max(implicitWidth, control.contentItem.width, control.popup.contentWidth)
        radius: control.radius - control.padding - inset
        inset: 2

        required property var model
        required property int index

        text: model[control.textRole]
        highlighted: index == control.highlightedIndex
    }

    // !! Warning: it seems that using a Popup {} in a Qs Window with focusable:true causes popup to immediately close.
    // It also seems to trigger any HyprlandFocusGrab
    popup: C.Menu {
        padding: control.padding
        y: control.height
        implicitWidth: contentWidth + leftPadding + rightPadding
        implicitHeight: contentHeight + topPadding + bottomPadding // Can't be 0 or qs will crash
        width: Math.max(control.background.width, implicitWidth)
        height: Math.max(1, implicitHeight)
        closePolicy: C.Popup.NoAutoClose // Doesn't seem to take effect
        //popupType: C.Popup.Native // Used to render the popup as it's own window
        background: Rectangle {
            color: Root.State.colors.surface
            radius: control.radius
        }
        contentItem: ListView {
            // contentHeight / contentWidth seem to no work in some cases?
            implicitWidth: contentItem.childrenRect.width
            implicitHeight: contentItem.childrenRect.height
            model: control.delegateModel // Provides both the model and delegate
        }
        // WARNING!: The exit Transition a Popup doesn't seem to play unless esc is used to close
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
        anchors.right: control.right
        anchors.verticalCenter: control.verticalCenter
        anchors.margins: 8
        width: 8
        height: 8
        color: "transparent"

        // Background
        Canvas {
            id: canvas
            antialiasing: true
            anchors.fill: parent
            // When it's time to render the canvas
            //Component.onCompleted: canvas.requestPaint()
            onPaint: {
                // Generate a 2d context to draw in
                let ctx = canvas.getContext("2d")
                ctx.fillStyle = control.color
                ctx.strokeStyle = control.color
                ctx.lineWidth = 0
                ctx.lineCap = "round" 

                ctx.beginPath() // Starts at 0,0
                ctx.moveTo(0, 0)
                ctx.lineTo(width, 0)
                ctx.lineTo(width/2, height)
                ctx.lineTo(0,0) // Back to origin
                ctx.fill()
                ctx.stroke() // Actually draw the path
                ctx.closePath()
            }
        }
    }
}
