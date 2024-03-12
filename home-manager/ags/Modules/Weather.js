import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { weather } from '../variables.js'

/*
WMO Weather interpretation codes (WW)
Code 	Description
0 	Clear sky
1, 2, 3 	Mainly clear, partly cloudy, and overcast
45, 48 	Fog and depositing rime fog
51, 53, 55 	Drizzle: Light, moderate, and dense intensity
56, 57 	Freezing Drizzle: Light and dense intensity
61, 63, 65 	Rain: Slight, moderate and heavy intensity
66, 67 	Freezing Rain: Light and heavy intensity
71, 73, 75 	Snow fall: Slight, moderate, and heavy intensity
77 	Snow grains
80, 81, 82 	Rain showers: Slight, moderate, and violent
85, 86 	Snow showers slight and heavy
95 * 	Thunderstorm: Slight or moderate
96, 99 * 	Thunderstorm with slight and heavy hail
*/
function LookupWeatherCode(code){
    switch(code) {
        case 0:
            return "Clear sky"
        case 1:
            return "Mostly clear"
        case 2:
            return "Partly cloudy"
        case 3:
            return "Overcast"
        default:
            return "Unknown"
} 
}

export const Weather = (w, h) => Widget.Box({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
        background-image: url("/home/eXia/Downloads/clear.jpg");
    `,
    children: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            vpack: "center",
            spacing: 4,
            children: [
                //Temperature
                Widget.Box({
                    children:[
                        // Current temp
                        Widget.Label({
                            hexpand: true,
                            css: `
                                font-size: 1.4rem;
                            `,
                            label: weather.bind().transform(weather => Math.round(weather.current.temperature_2m).toString() + weather.current_units.temperature_2m.toString()),
                        }),
                        Widget.Box({
                            vertical: true,
                            hexpand: true,
                            css: `
                                font-size: 0.8rem;
                            `,
                            children: [
                                // Hi
                                Widget.Label({
                                    hpack: "start",
                                    label: weather.bind().transform(weather => "hi: " + weather.daily.temperature_2m_max[0].toString() + weather.current_units.temperature_2m.toString()),
                                }),
                                // Lo
                                Widget.Label({
                                    hpack: "start",
                                    label: weather.bind().transform(weather => "lo: " + weather.daily.temperature_2m_min[0].toString() + weather.current_units.temperature_2m.toString()),
                                }),

                            ]
                        })
                    ]
                }),
                // Status
                Widget.Label({
                    label: weather.bind().transform(weather => LookupWeatherCode(weather.current.weather_code)),
                }),
                Widget.Box({
                    children: [
                        // Precipitation
                        Widget.Label({
                            hexpand: true,
                            label: weather.bind().transform(weather => " " + weather.current.precipitation.toString() + "%"),
                        }),
                        // Humidity
                        Widget.Label({
                            hexpand: true,
                            label: weather.bind().transform(weather => " " + weather.current.relative_humidity_2m.toString() + "%"),
                        }),
                    ]
                }),
            ]
        })
    ]
}) 