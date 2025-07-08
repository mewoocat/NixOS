import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules/Common" as Common
import "./Templates/"

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
