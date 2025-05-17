import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    Repeater {
        model: SystemTray.items

        Text {
            required property SystemTrayItem modelData;
            text: `Item: ${modelData.title}`
        }
    }
}
