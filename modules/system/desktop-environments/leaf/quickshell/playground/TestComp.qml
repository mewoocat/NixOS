import QtQuick

Rectangle {
    id: root
    required property string text
    color: "red"
    width: 100
    height: 100
    Text {
        text: root.text
    }
}
