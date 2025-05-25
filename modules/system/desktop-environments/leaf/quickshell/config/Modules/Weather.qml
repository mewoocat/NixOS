import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "root:/Services" as Services

ColumnLayout {
    anchors.margins: 8
    anchors.fill: parent
    Text {
        color: palette.text
        text: `Temp: ${Services.Weather.current.temperature_2m}`
    }
    Text {
        color: palette.text
        text: `Feels like: ${Services.Weather.current.apparent_temperature}`
    }
    Text {
        color: palette.text
        text: `Precipitation %: ${Services.Weather.current.precipitation}`
    }
    Text {
        color: palette.text
        text: Services.Weather.lookupCode(Services.Weather.current.weather_code).name
    }
    IconImage {
        implicitSize: 20
        source: {
            const data = Services.Weather.lookupCode(Services.Weather.current.weather_code)
            const icon = Quickshell.iconPath(data.icon)
            return icon
        }
    }
    Text {
        color: palette.text
        //text: `what: ${Root.State.jsonData.what}`
    }

    /*
                root.current.temperature_2m = jsonData.current.temperature_2m
                root.current.apparent_temperature = jsonData.current.apparent_temperature
                root.current.precipitation = jsonData.current.precipitation
                root.current.weather_code = jsonData.current.weather_code
                root.current.relative_humidity_2m = jsonData.current.relative_humidity_2m
                */
}
