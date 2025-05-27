import Quickshell
import Quickshell.Widgets
import QtQuick
import "root:/" as Root

IconImage {
    implicitSize: 64
    anchors.centerIn: parent
    //source: Root.State.config.funImage
    source: Quickshell.iconPath('systemsettings')
}
