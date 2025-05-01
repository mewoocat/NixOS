import QtQuick
import "Singletons" as Sin

Text {
    id: clock
    color: "#ffffff"
    // Centers relative to parent
    anchors.centerIn: parent
    text: Sin.Time.time
}
