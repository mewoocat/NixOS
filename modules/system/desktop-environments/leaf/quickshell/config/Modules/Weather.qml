import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "root:/Services" as Services

ColumnLayout {
    anchors.margins: 8
    anchors.fill: parent

    RowLayout {
        Layout.fillWidth: true
        IconImage {
            implicitSize: 48
            source: {
                const data = Services.Weather.lookupCode(Services.Weather.current.weather_code)
                const icon = Quickshell.iconPath(data.icon)
                return icon
            }
        }

        // For some reason setting the fill Width/Height directly on the ColumnLayout
        // doesn't make it expand fully.  Wrapping it in a rectangle fixes it, idk why.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            ColumnLayout {
                anchors.centerIn: parent
                Text {
                    color: palette.text
                    font.pointSize: 20
                    text: `${Services.Weather.current.temperature_2m}`
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    color: palette.text
                    font.pointSize: 10
                    text: `${Services.Weather.daily.temperature_2m_min[0]} | ${Services.Weather.daily.temperature_2m_max[0]}`
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
    /*
    Text {
        color: palette.text
        text: `Precipitation %: ${Services.Weather.current.precipitation}`
    }
    Text {
        color: palette.text
        text: Services.Weather.lookupCode(Services.Weather.current.weather_code).name
    }
    Text {
        color: palette.text
        text: `lat/lon: ${Services.Weather.latitude}/${Services.Weather.longitude}`
    }
    */
}
