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
            }

            // Popup menu
            // probably need to give a size to the anchor rectangle for it to show anything?
            QsMenuAnchor {
                //anchor.window: bar
                anchor.window: button.QsWindow.window
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
