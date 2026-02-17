import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf

PageBase {
    pageName: "Display" 
    content: ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        SectionBase { name: "Brightness"}
        RowLayout {
            Text {
                text: "Display 1"
                color: palette.text
            }
            Slider {
                Layout.fillWidth: true
                from: 0.01
                value: Services.Brightness.value
                //stepSize: 0.01
                onValueChanged: {
                    Services.Brightness.value = value
                }
                to: 1
            }
        }

        SectionBase { name: "Night Light"}
        RowLayout {
            Text {
                text: "Warmth"
                color: palette.text
            }
            Slider {
                Layout.fillWidth: true
                from: 1
                value: 1000
                stepSize: 1
                onValueChanged: {
                }
                to: 9000
            }
        }
    }
}
