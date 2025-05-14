import Quickshell
import QtQuick

GridLayout {
    Layout.preferredWidth: Layout.columnSpan > 1 ? size * Layout.columnSpan : size
    Layout.preferredHeight: size
    //uniformCellWidths: true
    //uniformCellHeights: true
    columnSpacing: 0
    rowSpacing: 0
    implicitWidth: parent.width
    implicitHeight: parent.height
    columns: 2
    rows: 2

}
