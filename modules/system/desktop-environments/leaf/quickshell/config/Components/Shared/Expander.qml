import QtQuick
import Quickshell.Widgets

WrapperRectangle {
    id: root
    //anchors.fill: parent
    Component.onCompleted: root.dumpItemTree()
    required property Item button
    required property Component content
    required property Item backdrop
    property int collaspedWidth: root.width
    property int collaspedHeight: root.height
    property int expandedWidth: backdrop.width
    property int expandedHeight: backdrop.height
    onCollaspedWidthChanged: console.debug(`collaspedWidth: ${collaspedWidth}`)
    onCollaspedHeightChanged: console.debug(`collaspedHeight: ${collaspedHeight}`)
    onExpandedWidthChanged: console.debug(`expandedWidth: ${expandedWidth}`)
    onExpandedHeightChanged: console.debug(`expandedHeight: ${expandedHeight}`)
    onWidthChanged: console.debug(`Expander x: ${x}`)
    onHeightChanged: console.debug(`Expander y: ${y}`)

    property Item contentItem: contentLoader.item as Item
    property point buttonOrigin: backdrop.mapFromItem(root, 0, 0) // The window padding is causing this to be mispositioned
    onButtonOriginChanged: console.debug(`buttenOrigin: ${buttonOrigin}`)

    property Loader contentLoader: Loader {
        parent: root.backdrop
        x: root.buttonOrigin.x
        y: root.buttonOrigin.y
        width: root.collaspedWidth
        height: root.collaspedHeight
        sourceComponent: root.content
    }

    function showContent() {
        console.debug(`showing content: ${root.backdrop}`)
        console.debug(`button origin: ${root.buttonOrigin}`)
        contentLoader.x = 0
        contentLoader.y = 0
        contentLoader.width = expandedWidth
        contentLoader.height = expandedHeight
    }

    function hideContent() {
        // Reset the content's position back to the button
        contentLoader.x = buttonOrigin.x
        contentLoader.y = buttonOrigin.y
        contentLoader.width = collaspedWidth
        contentLoader.height = collaspedHeight
    }

    children: [
        button
    ]

    /*
    Loader {
        id: buttonBox
        anchors.fill: parent
        sourceComponent: root.button
    }
    */
}
