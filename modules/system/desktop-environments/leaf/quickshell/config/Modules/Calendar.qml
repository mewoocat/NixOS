import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/" as Root
import "root:/Modules/Common" as Common


ColumnLayout {
    anchors.centerIn: parent
    Rectangle {
        //color: "red"
        color: "transparent"
        Layout.fillWidth: true
        implicitHeight: 40
        Common.NormalButton {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            iconName: "arrow-left"
            leftClick: () => {
                if (monthGrid.month === Calendar.January) {
                    monthGrid.month = Calendar.December
                }
                else {
                    monthGrid.month += -1
                }
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            text: monthGrid.locale.monthName(monthGrid.month)
            verticalAlignment: Text.AlignVCenter
            //Rectangle {anchors.fill: parent; color: "#9900ff00"}
            font.pointSize: 12
            color: palette.text
        }
        Common.NormalButton {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            iconName: "arrow-right"
            leftClick: () => {
                if (monthGrid.month === Calendar.December) {
                    monthGrid.month = Calendar.January
                }
                else {
                    monthGrid.month += 1
                }
            }
        }
    }
    MonthGrid {
        id: monthGrid
        delegate: Text {
            text: model.day
            color: {
                if (model.month != monthGrid.month) {
                    return palette.window
                }
                return palette.text
            }
            font.pointSize: 10
        }
    }
}
