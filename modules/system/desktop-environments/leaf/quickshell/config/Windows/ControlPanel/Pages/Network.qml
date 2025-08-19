import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import qs.Services as Services

PageBase {
    pageName: "Network"
    content: ColumnLayout {
        Text {
            //text: `network stuff goes here: ${Services.Network.test}`
            color: palette.text
        }
        Button {
            text: "test"
            onClicked: () => {
                Services.OSD.visible = !Services.OSD.visible
            }
        }
    }
}
