import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "root:/" as Root
import "root:/Modules/Common" as Common

ColumnLayout {
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }
    Button {
        text: "test"
    }
}
