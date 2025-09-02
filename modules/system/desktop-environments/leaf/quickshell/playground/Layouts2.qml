import QtQuick
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    color: "grey"

    Rectangle {
        implicitWidth: 600
        implicitHeight: 150
        anchors.centerIn: parent
        
        GridLayout {
            anchors.fill: parent
            columns: 4
            rows: 4
            rowSpacing: 0
            columnSpacing: 0
            Rectangle {
                //Layout.fillWidth: true
                implicitWidth: height
                //Layout.horizontalStretchFactor: 1
                Layout.fillHeight: true
                Layout.rowSpan: 4
                Layout.columnSpan: 1
                Layout.column: 0
                //Layout.alignment: Qt.AlignRight
                color: 'red'
            }
            /*
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 50
                //Layout.fillHeight: true
                Layout.columnSpan: 2
                Layout.row: 0
                Layout.column: 1
                color: 'purple'
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.row: 1
                Layout.column: 1
                Layout.columnSpan: 2
                color: 'pink'
            }
            Rectangle {
                implicitWidth: 64
                Layout.fillHeight: true
                Layout.columnSpan: 1
                Layout.rowSpan: 2
                Layout.row: 0
                Layout.column: 3
                Layout.alignment: Qt.AlignRight
                color: 'orange'
            }
            */
            /*
            Rectangle {
                //Layout.horizontalStretchFactor: 1
                Layout.fillWidth: true
                //implicitWidth: 400
                Layout.fillHeight: true
                Layout.row: 2
                Layout.column: 1
                Layout.columnSpan: 3
                color: 'blue'
            }
            */
            Rectangle {
                //Layout.fillWidth: true
                //Layout.horizontalStretchFactor: 1
                implicitHeight: 40
                implicitWidth: 60
                Layout.row: 3
                Layout.column: 1
                Layout.columnSpan: 1
                color: 'green'
            }
            Rectangle {
                //Layout.fillWidth: true
                implicitHeight: 40
                //Layout.horizontalStretchFactor: 1
                implicitWidth: 60
                Layout.row: 3
                Layout.column: 2
                Layout.columnSpan: 1
                color: 'green'
            }
            Rectangle {
                //Layout.fillWidth: true
                implicitHeight: 40
                //Layout.horizontalStretchFactor: 1
                implicitWidth: 60
                Layout.row: 3
                Layout.column: 3
                Layout.columnSpan: 1
                color: 'green'
            }
        }
    }
}
