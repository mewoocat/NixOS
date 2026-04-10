import QtQuick
import Quickshell.Widgets

WrapperRectangle {
    id: root

    required property Item button
    required property Component content
    required property Item backdrop

    property int collaspedWidth: root.width
    property int collaspedHeight: root.height
    property int expandedWidth: backdrop.width
    property int expandedHeight: backdrop.height
    property Item contentItem: contentLoader.item as Item
    property point buttonOrigin: backdrop.mapFromItem(root.child, 0, 0)
    property int animationSpeed: 500
    property var easingType: Easing.InOutQuint

    property Loader contentLoader: Loader {
        opacity: 0
        Behavior on opacity { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        parent: root.backdrop
        x: root.buttonOrigin.x
        y: root.buttonOrigin.y
        Behavior on x { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on y { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        width: root.collaspedWidth
        height: root.collaspedHeight
        Behavior on width { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        Behavior on height { PropertyAnimation { duration: root.animationSpeed; easing.type: root.easingType; } }
        sourceComponent: root.content
    }

    function showContent() {
        contentLoader.opacity = 1
        contentLoader.x = 0
        contentLoader.y = 0
        contentLoader.width = expandedWidth
        contentLoader.height = expandedHeight
    }

    function hideContent() {
        contentLoader.opacity = 0
        // Reset the content's position back to the button
        contentLoader.x = buttonOrigin.x
        contentLoader.y = buttonOrigin.y
        contentLoader.width = collaspedWidth
        contentLoader.height = collaspedHeight
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
