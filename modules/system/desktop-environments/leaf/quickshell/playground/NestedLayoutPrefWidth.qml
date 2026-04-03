import QtQuick
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    color: "black"
    implicitHeight: 400
    implicitWidth: 400

    ColumnLayout {
        RowLayout {
            //implicitHeight: 200
            Layout.preferredHeight: 200
            Rectangle {
                implicitWidth: 200
                Layout.fillHeight: true
            }
        }
    }
}
