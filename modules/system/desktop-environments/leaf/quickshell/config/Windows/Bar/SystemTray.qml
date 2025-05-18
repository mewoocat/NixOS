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
            id: button
            required property SystemTrayItem modelData
            leftClick: () => {modelData.activate()}
            rightClick: () => {
                console.log("rightClick")
                //modelData.display(root.QSWindow,0,0)
                menuAnchor.open()
            }

            // Popup menu
            // probably need to give a size to the anchor rectangle for it to show anything?
            QsMenuAnchor {
                id: menuAnchor
                //anchor.window: bar
                anchor {
                    window: button.QsWindow.window
                    edges: Edges.Bottom | Edges.Left
                    // Get a rect for the popup that is relative to the button item
                    // The returned rect is then in the context of the window
                    rect: button.QsWindow.window.contentItem.mapFromItem(button, Qt.rect(0, 0, 0, 40))
                    //rect: button.QsWindow.window.mapFromItem(button, 100, 100, 400, 400)
                    /*
                    rect {
                        //x: 100
                        //y: 100
                        //width: 300
                        //height: 300
                        //w: 300
                        //h: 300
                    }
                    */
                }
                menu: modelData.menu
            }

            iconSource: modelData.icon != undefined ? modelData.icon : ""
            //iconSource: modelData != undefined ? modelData.icon : ""
            //iconName: modelData.icon != undefined ? modelData.icon : "image://icon/state-ok"
            //iconName: "help-browser-symbolic"
            //text: modelData.title
        }
    }
}
