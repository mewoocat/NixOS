import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { weather } from '../variables.js'

export const Weather = (w, h) => Widget.Box({
    class_name: "weather",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    children: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            vpack: "center",
            children: [
                // Temp
                Widget.Label({
                    css: `
                        font-size: 1.4rem;
                    `,
                    label: weather.bind().transform(weather => Math.round(weather.current.temperature_2m).toString() + weather.current_units.temperature_2m.toString()),
                }),
                // Status
                Widget.Label({
                    label: weather.bind().transform(weather => "Code " + weather.current.weather_code.toString()),
                }),
            ]
        })
    ]
}) 