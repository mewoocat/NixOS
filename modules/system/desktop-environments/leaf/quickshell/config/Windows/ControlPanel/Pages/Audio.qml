import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../../../" as Root
import "../../../Modules/Common" as Common

ColumnLayout {
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }
    Button {
        text: "test"
    }
}
