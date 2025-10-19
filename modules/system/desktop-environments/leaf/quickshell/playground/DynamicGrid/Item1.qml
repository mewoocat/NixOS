pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

PanelItem {
    anchors.fill: parent
    widgetId: "item1"
    cellRowSpan: 1
    cellColumnSpan: 1
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "red"
    }
}
