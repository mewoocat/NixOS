import QtQuick
import Quickshell

import qs.Services as Services

PanelWindow {
    width: 200
    height: 200
    color: "transparent"
    visible: Services.OSD.visible
    Rectangle {
        anchors.margins: 8
        anchors.fill: parent
        color: palette.base
        radius: 8
    }
}
