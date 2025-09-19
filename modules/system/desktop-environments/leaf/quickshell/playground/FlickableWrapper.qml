import QtQuick
import QtQuick.Controls
import Quickshell

FloatingWindow {
    color: "grey"
    Flickable {
        implicitWidth: 300
        implicitHeight: 300
        contentWidth: 600
        contentHeight: 600
        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: ScrollBar {}
        children: [
            Rectangle {
                color: "green"
                implicitWidth: 300
                implicitHeight: 300
            }
        ]
    }
    
    component FlickableWrapper: Flickable {
        required property Item content
        x: 350
        implicitWidth: 300
        implicitHeight: 300
        contentWidth: 600
        contentHeight: 600
        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: ScrollBar {}
        children: [
            content
        ]
    }

    FlickableWrapper {
        content: Rectangle {
            color: "red"
            implicitWidth: 300
            implicitHeight: 300
        }
    }
}
