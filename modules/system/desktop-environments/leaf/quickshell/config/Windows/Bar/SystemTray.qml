import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "root:/Modules/Ui" as Ui


RowLayout {
    id: root
    required property var window
    Repeater {
        model: SystemTray.items
        /*
        model: ScriptModel {
            values: [...SystemTray.items.values]
        }
        */
        /*
        IconImage {
            source: modelData.icon
            implicitSize: 18
        }
        */
        Ui.NormalButton {
            required property SystemTrayItem modelData

            id: button
            iconSource: modelData.icon != undefined ? modelData.icon : ""
            leftClick: modelData.activate
            rightClick: menuAnchor.open

            // Popup menu
            QsMenuAnchor {
                id: menuAnchor
                //anchor.window: bar
                anchor {
                    window: button.QsWindow.window
                    edges: Edges.Bottom | Edges.Left
                    // Get a rect for the popup that is relative to the button item
                    // The returned rect is then in the context of the window
                    rect: button.QsWindow.window.contentItem.mapFromItem(button, Qt.rect(0, 0, 0, 40))
                }
                menu: modelData.menu
            }
        }
    }
}
