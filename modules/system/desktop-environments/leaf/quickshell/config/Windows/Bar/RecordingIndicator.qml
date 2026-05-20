import QtQuick
import qs.Services as Services

Rectangle {
    visible: Services.ScreenCapture.recording
    implicitWidth: 4
    implicitHeight: 4
    radius: 4
    color: "red"
}
