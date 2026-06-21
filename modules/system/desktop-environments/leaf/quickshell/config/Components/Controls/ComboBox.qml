pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls as C
import QtQuick.Templates as T
import qs as Root

T.ComboBox {
    id: control

    hoverEnabled: enabled

    //defines the padding of the contentItem relative to the edge of the control
    padding: 4
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
    bottomPadding: padding

    // Defines the padding of the background
    property real inset: 4
    leftInset: inset
    rightInset: inset
    topInset: inset
    bottomInset: inset

    property color backgroundColor: control.hovered ? Root.State.colors.surface_container_highest : Root.State.colors.surface_container_high
    property color color: control.hovered ? Root.State.colors.on_surface : Root.State.colors.on_surface
    property bool isMutliColorIcon: false
    property int radius: 12
    property int minDelegateWidth: 200

    // This is a super hacky solution and expects that the model passed to the combobox will always be an object and have a coresponding textRole prop
    property int maxDelegateWidth: delegateTextMetrics.width
    TextMetrics {
        id: delegateTextMetrics
        // Runs the provided callback for every item in the array and removes the item not returned
        // Useful to find the longest text here
        text: {
            //console.log(`combobox model: ${model}`)
            const objWithLongestText = model.reduce((previous, current) => {
                //console.log(`prev: ${previous}`)
                //console.log(`current: ${current}`)
                const previousText = previous[control.textRole]
                const currentText = current[control.textRole]
                if (!previous || currentText.length > previousText.length) return current
                return previous
            })
            //console.debug(`width text: ${objWithLongestText[control.textRole]}`)
            return objWithLongestText[control.textRole]
        }
    }

    // The size of the control is determined by whether the background and the inset or content and padding is largest
    // See: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#implicitBackgroundHeight-prop
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        id: bg
        implicitWidth: 120
        implicitHeight: 24
        color: control.backgroundColor
        radius: control.radius
        opacity: control.enabled ? 1 : 0.5
    }

    contentItem: Rectangle {
        color: "#0000ff00"
        Text {
            anchors.centerIn: parent
            width: parent.width
            leftPadding: 8
            rightPadding: control.indicator.width + control.rightPadding + 8
            text: control.displayText
            color: control.color
            elide: Text.ElideRight
        }
    }

    delegate: MenuItem {
        id: delegate
        required property var model
        required property int index
        hoverEnabled: control.hoverEnabled
        implicitWidth: control.maxDelegateWidth + 40
        radius: control.radius - control.padding - inset
        text: model[control.textRole]
        highlighted: index == control.highlightedIndex
    }

    // !! Warning: it seems that using a Popup {} in a Qs Window with focusable:true causes popup to immediately close.
    // It also seems to trigger any HyprlandFocusGrab
    //
    // TODO: might want to move this to it's own file
    popup: C.Menu {
        id: popup
        clip: true
        padding: control.padding
        x: control.inset
        y: control.height
        // This is the default but for some reason specifying it here results in clicking on the control to close the popup not working
        closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnReleaseOutside
        //popupType: C.Popup.Native // Used to render the popup as it's own window. Seems to cause issues with animation
        //popupType: C.Popup.Window
        popupType: C.Popup.Item
        background: Rectangle {
            color: "red"//Qt.alpha(Root.State.colors.surface, 1)
            radius: control.radius
            /*
            border {
                width: 1
                color: "red"
            }
            */
        }
        contentItem: ListView {
            // For some reason, only implicit sizes seem to apply here
            implicitWidth: control.maxDelegateWidth + 40
            implicitHeight: contentItem.childrenRect.height
            model: control.delegateModel // Provides both the model and delegate
        }
        enter: Transition {
            NumberAnimation { property: "height"; from: 1; to: popup.implicitHeight; duration: 250 }
        }
        exit: Transition {
            NumberAnimation { property: "height"; from: popup.implicitHeight; to: 1; duration: 250 }
        }
    }

    indicator: Rectangle {
        anchors.right: control.contentItem.right
        anchors.verticalCenter: control.verticalCenter
        anchors.margins: 8
        width: 8
        height: 8
        color: "transparent"
        opacity: control.enabled ? 1 : 0.5

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
