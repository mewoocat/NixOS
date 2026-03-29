import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.Components.Controls as Ctrls
import qs as Root

// TODO: Write our own tooltip window using a qs PopupWindow.  This will allow for bluring
// Defines an area and content for a tooltip popup to occur in
WrapperMouseArea {

    id: area
    required property string text
    property color backgroundColor: Root.State.colors.surface
    hoverEnabled: true
    property ToolTip toolTip: Ctrls.ToolTip {
        text: area.text
        visible: area.containsMouse
    }

    onEntered: {
        //console.log("entered")
    }

    onExited: {
        //console.log("exited")
    }
}
