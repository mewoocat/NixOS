import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules/Common" as Common

ColumnLayout {
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }

    Text {
        text: "network stuff goes here"
    }
    Button {
        text: "test"
    }
}
