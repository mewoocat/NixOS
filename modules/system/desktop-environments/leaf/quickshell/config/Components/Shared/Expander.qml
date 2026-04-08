import QtQuick
import Quickshell.Widgets

WrapperItem {
    id: root
    required property Item button
    required property Component content
    required property Item backdrop

    property Loader contentLoader: Loader {
        parent: null // Don't render (i think it's null by default here)
        sourceComponent: root.content
    }

    function showContent() {
        console.debug(`showing content`)
        contentLoader.parent = backdrop
    }

    function hideContent() {
        contentLoader.parent = null
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
