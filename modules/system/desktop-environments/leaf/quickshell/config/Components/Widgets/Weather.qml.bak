pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetDefinition {
    id: root
    uid: "weather-2x2"
    name: "Weather (2x2)"
    xSize: 2
    ySize: 2
    defaultState: null
    component: Rectangle {
        anchors.fill: parent
        color: "transparent"

        ColumnLayout { 
            anchors.centerIn: parent
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
                        color: Root.State.colors.on_surface
                        font.pointSize: 20
                        text: `${Services.Weather.current.temperature_2m}`
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        color: Root.State.colors.on_surface
                        font.pointSize: 8
                        text: `${Services.Weather.daily.temperature_2m_min[0]} | ${Services.Weather.daily.temperature_2m_max[0]}`
                    }
                }
            }

            Text {
                color: Root.State.colors.on_surface
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
                        radius: Root.State.rounding
                        color: Root.State.colors.surface
                    }
                }

                RowLayout {
                    IconImage {
                        implicitSize: 18
                        source: Quickshell.iconPath("raindrop")
                    }
                    Text {
                        color: Root.State.colors.on_surface
                        text: Services.Weather.current.precipitation + '%'
                        font.pointSize: 8
                    }
                }
            }
        }
    }
}
