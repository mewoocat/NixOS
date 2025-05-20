import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Rectangle {
    anchors.fill: parent
    color: "transparent"
    MonthGrid {
        anchors.centerIn: parent
        delegate: Text {
            text: model.day
            font.pointSize: 8
        }
    }
}
