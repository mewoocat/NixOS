import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Components.Controls as Ctrls

RowLayout {
    Ctrls.Button {
        icon.name: Services.Brightness.getIcon()
        text: Math.ceil(Services.Brightness.value * 100) + '%'
        onClicked: () => brightnessExpander.expanded = true
        implicitWidth: icon.width + spacing + leftPadding + rightPadding + brightnessTextMetrics.width
        TextMetrics {
            id: brightnessTextMetrics
            text: "100%"
        }
    }
    Ctrls.Slider {
        Layout.fillWidth: true
        from: 0.01
        value: Services.Brightness.value
        //stepSize: 0.01
        onValueChanged: Services.Brightness.value = value
        to: 1
        onPressedChanged: () => {
            if (!pressed) { Services.Brightness.setDDCCIBrightness(value * 100) }
        }
    }
}
