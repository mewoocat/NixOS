import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Modules.Common as Common

ColumnLayout {
    anchors.centerIn: parent
    spacing: 0
    // Note that the NormalButtons have margins which increase the size of the RowLayout height
    RowLayout {
        spacing: 0
        Layout.fillWidth: true
        Common.NormalButton {
            Layout.alignment: Qt.AlignLeft
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
            Layout.fillWidth: true
            text: monthGrid.locale.monthName(monthGrid.month)
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 10
            color: palette.text
        }
        Common.NormalButton {
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
        spacing: 0
        delegate: Rectangle {
            id: day
            required property var model
            radius: 20
            implicitHeight: text.height
            implicitWidth: text.width
            color: {
                if (model.today) {
                    return palette.highlight
                }
                return "transparent"
            }
            Text {
                anchors.centerIn: parent
                id: text
                text: day.model.day
                padding: 4
                color: palette.text
                opacity: {
                    if (day.model.month != monthGrid.month) {
                        return 0.3
                    }
                    return 1
                }
                font.pointSize: 10
            }
        }
    }
}
