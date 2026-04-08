import QtQuick
import Quickshell.Widgets

WrapperItem {
    id: root
    required property Item button
    required property Component content
    required property Item backdrop
    // This is a hack, find a better solution
    onBackdropChanged: () => {
        console.debug(`backdrop changed ${backdrop}, ${buttonOrigin.x}`)
        // Re-parent the content to the backdrop
        contentItem.parent = backdrop
        // Need to recalculate since it's could have been null
        buttonOrigin = contentItem.mapFromItem(button, 0, 0)
        // On Initial load set the content's position to the button
        contentItem.x = buttonOrigin.x
        contentItem.y = buttonOrigin.y
    }
    Component.onCompleted: console.debug(`backdrop: ${backdrop}`)
    property Item contentItem: contentLoader.item as Item
    property point buttonOrigin: contentItem.mapFromItem(button, 0, 0)

    property Loader contentLoader: Loader {
        sourceComponent: root.content
    }

    function showContent() {
        console.debug(`showing content: ${root.backdrop}`)
        //contentItem.x = 0
        //contentItem.y = 0
    }

    function hideContent() {
        // Reset the content's position back to the button
        contentItem.x = buttonOrigin.x
        contentItem.y = buttonOrigin.y
    }

    child: button

    

    /*
    property Connections btnConn: Connections {
        target: root.button
        function onClicked() {
            root.showContent()
            console.log(`eeeeeee`)
        }
    }
    */
}
