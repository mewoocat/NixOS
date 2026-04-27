import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

Shared.PanelWindow {
    id: root
    visible: false
    color: "transparent"
    focusable: true
    content: WrapperRectangle {
        anchors.centerIn: parent
        color: Root.State.colors.surface
        radius: 10//Root.State.rounding
        margin: 9
        ColumnLayout {
            Shared.TextBlock {
                text: "Connect to Network"
            }
            Ctrls.TextField {

            }
        }
    }
}
