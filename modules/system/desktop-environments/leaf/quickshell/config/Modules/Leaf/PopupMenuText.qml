import QtQuick
import Quickshell.Widgets

WrapperItem {
    id: root
    margin: 6
    required property string text
    required property color color
    Text {
        text: root.text
        color: root.color
    }
}
