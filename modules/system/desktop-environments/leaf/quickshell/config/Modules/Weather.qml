import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services

Item {
    anchors.margins: 16
    anchors.fill: parent

    ColumnLayout { 
        spacing: 10
        RowLayout {
            Layout.alignment: Qt.AlignTop
            IconImage {
                implicitSize: 44
                source: {
                    const data = Services.Weather.lookupCode(Services.Weather.current.weather_code)
                    const icon = Quickshell.iconPath(data.icon)
                    return icon
                }
            }

            ColumnLayout {
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: palette.text
                    font.pointSize: 20
                    text: `${Services.Weather.current.temperature_2m}`
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: palette.text
                    font.pointSize: 8
                    text: `${Services.Weather.daily.temperature_2m_min[0]} | ${Services.Weather.daily.temperature_2m_max[0]}`
                }
            }
        }

        Text {
            color: palette.text
            text: Services.Weather.lookupCode(Services.Weather.current.weather_code).name
            font.pointSize: 12
        }

        WrapperMouseArea {
            id: precipitation 
            hoverEnabled: true
            ToolTip {
                delay: 300
                text: "Current humidity"
                visible: precipitation.containsMouse
                background: Rectangle {
                    radius: 20
                    color: palette.window
                }
            }

            RowLayout {
                IconImage {
                    implicitSize: 18
                    source: Quickshell.iconPath("raindrop")
                }
                Text {
                    color: palette.text
                    text: Services.Weather.current.precipitation + '%'
                    font.pointSize: 8
                }
            }
        }
        /*
        Text {
            color: palette.text
            text: `lat/lon: ${Services.Weather.latitude}/${Services.Weather.longitude}`
        }
        */
    }
}
