pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Modules.Common as Common


Common.PopupWindow {
    id: root
    required property Item parentButton // The button that this popup will be relative to
    required property var menu // The menu object that describes the content
    property bool isNested: false
    //Component.onCompleted: console.log(`isNested: ${isNested}`)

    anchor {
        // Only window or item should be set at a time, otherwise a crash can occur
        item: parentButton
        edges: Edges.Top | Edges.Left
        gravity: Edges.Bottom | Edges.Left
        margins.left: -8
    }

    // Used to extract the menu items from the menu
    QsMenuOpener {
        id: menuOpener
        menu: root.menu
    }

    content: ColumnLayout {
        id: menuContent
        Repeater {
            model: menuOpener.children
            delegate: Loader {
                id: loader
                required property QsMenuEntry modelData
                // This seems to be required when wrapping with a loader
                Layout.fillWidth: true // It appears that this propagates through the 
                active: true
                // These are the possible components that would need to be loaded here
                // They are only Components which define a type to be created, not actual
                // instances of the type
                // Event though it looks like these are creating the component, the Component type
                // here should be coercing it into a Component instead
                property Component menuSeperator: Rectangle {
                    implicitHeight: 1
                    implicitWidth: menuContent.width
                    color: "#44ffffff"
                }
                property Component menuItem: MenuEntry { 
                    entry: loader.modelData
                    //Layout.fillWidth: true // It appears that this propagates through the 
                }
                // The selected component is instantiated here
                sourceComponent: modelData.isSeparator ? menuSeperator : menuItem
            }
        }
    }
}
