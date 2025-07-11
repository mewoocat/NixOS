import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import "root:/Services" as Services

// TODO: Write our own tooltip window using a qs PopupWindow.  This will allow for bluring
// Defines an area and content for a tooltip popup to occur in
WrapperMouseArea {
    id: area
    required property string text
    hoverEnabled: true
    ToolTip {
        delay: 300
        text: area.text
        visible: area.containsMouse
        background: Rectangle {
            radius: 20
            color: "#77000000"
        }
    }

    onEntered: {
        //console.log("entered")
    }

    onExited: {
        //console.log("exited")
    }
}
