pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

PanelItem {
    widgetId: "item2"
    cellRowSpan: 2
    cellColumnSpan: 2
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "green"
    }
}
