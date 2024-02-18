import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { weather } from '../variables.js'





export const Weather = () => Widget.Box({
    children: [
        // Temp
        Widget.Label({
            label: weather.bind().transform(weather => "Temp " + weather.current.temperature_2m.toString() + weather.current_units.temperature_2m.toString()),
        }),
        // Status
        Widget.Label({
            label: weather.bind().transform(weather => "Code " + weather.current.weather_code.toString()),
        }),
    ]
})