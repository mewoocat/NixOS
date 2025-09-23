
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

FloatingWindow {
    color: "grey"

    WrapperMouseArea {
        id: root
        property Item content: Text {
            text: "main content"
        }
        property Item subContent: Text {
            text: "sub content"
        }
        property bool expanded: true
        hoverEnabled: true
        onClicked: subContent.visible = !subContent.visible
        //onClicked: background.height = content.height

        Rectangle {
            id: background
            implicitWidth: 200
            implicitHeight: root.content.height + root.subContent.height
            //clip: true
            color: root.containsMouse ? palette.alternateBase : "red"
            onHeightChanged: console.log(`height: ${height}`)
            Behavior on height {
                PropertyAnimation { 
                    duration: 500
                    easing.type: Easing.InOutQuint
                }
            }

            children: [ 
                root.content,
                root.subContent
            ]
        }
    }
}
