import Quickshell
import QtQuick
import QtQuick.Layouts

GridLayout {
    id: grid
    property int unitSize: 100

    uniformCellHeights: true
    uniformCellWidths: true
    width: unitSize * columns
    height: unitSize * rows
    columnSpacing: 0
    rowSpacing: 0

    //columns: 2
    //rows: 2
}
