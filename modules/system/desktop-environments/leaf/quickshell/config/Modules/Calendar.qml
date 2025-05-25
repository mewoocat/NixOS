import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "root:/" as Root
import "root:/Modules/Common" as Common

ColumnLayout {
    anchors.centerIn: parent

    RowLayout {
        Text {
            text: monthGrid.locale.monthName(monthGrid.month)
            color: palette.text
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
            font.pointSize: 8
        }
    }
}
