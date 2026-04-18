pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Components.Shared as Shared
import qs as Root
import qs.Components.Controls as Ctrls

Shared.PopupWindow {
    id: root
    required property Item parentButton // The button that this popup will be relative to
    required property QsMenuHandle menuHandle // The menu object that describes the content

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
        menu: root.menuHandle
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
                    color: Root.State.colors.on_surface_variant
                }
                property Component newMenuItem: Ctrls.MenuItem {
                    text: modelData.text
                }
                // The selected component is instantiated here
                sourceComponent: modelData?.isSeparator ? menuSeperator : newMenuItem
            }
        }
    }
}
