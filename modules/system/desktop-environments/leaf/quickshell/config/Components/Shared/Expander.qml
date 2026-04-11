import QtQuick
import Quickshell.Widgets

WrapperRectangle {
    id: root

    opacity: 0.3
    required property Item button
    required property Component content
    required property Item backdrop

    property int collaspedWidth: root.width
    property int collaspedHeight: root.height
    property int expandedWidth: backdrop.width
    property int expandedHeight: backdrop.height
    // IMPORTANT! Calculating the actual value here should be done after the component completes since it's 
    // position seems to shift around before then
    property point buttonOrigin: Qt.point(0,0)
    // Doing this seems to work for now.  Be warned that the order in which components are completed is undefined
    Component.onCompleted: { buttonOrigin = backdrop.mapFromItem(root.child, 0, 0) }

    property int animationSpeed: 500
    property var easingType: Easing.InOutQuint

    property Item contentItem: Loader {
        opacity: 1
        active: false
        parent: root.backdrop
        x: root.buttonOrigin.x
        y: root.buttonOrigin.y
        width: root.collaspedWidth
        height: root.collaspedHeight
        Behavior on opacity { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on x { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on y { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on width { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on height { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        sourceComponent: root.content
    }

    function showContent() {
        buttonOrigin = backdrop.mapFromItem(root.child, 0, 0)
        console.debug(`buttonOrigin: ${buttonOrigin}`)

        contentItem.active = true
        contentItem.opacity = 1
        contentItem.x = 0
        contentItem.y = 0
        contentItem.width = expandedWidth
        contentItem.height = expandedHeight
    }

    function hideContent() {
        //contentItem.opacity = 0
        contentItem.active = false
        contentItem.x = buttonOrigin.x
        contentItem.y = buttonOrigin.y
        contentItem.width = collaspedWidth
        contentItem.height = collaspedHeight
    }

    child: button

    /*
    Loader {
        id: buttonBox
        anchors.fill: parent
        sourceComponent: root.button
    }
    */
}
