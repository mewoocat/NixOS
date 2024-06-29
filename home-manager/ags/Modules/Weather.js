
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

///////////////////////////////////
//  Weather setup
///////////////////////////////////

// Read in user settings
const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))

var lat = data.lat
var lon = data.lon
//TODO add variables for units
var url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch`

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
    // Get day/night state
    // 

    switch(code) {
        case 0:
            return {
                icon: "weather-clear-symbolic", // "weather-clear-night-symbolic"
                name: "Clear sky",
            }
        case 1:
            return {
                icon: "weather-few-clouds-symbolic", // "weather-few-clouds-symbolic"
                name: "Mostly clear",
            }
        case 2:
            return {
                icon: "weather-few-clouds-symbolic", // "weather-few-clouds-symbolic"
                name: "Partly cloudy",
            }
        case 3:
            return {
                icon: "weather-overcast-symbolic",
                name: "Overcast",
            }
        case 45:
        case 48:
            return {
                icon: "weather-overcast-symbolic",
                name: "Overcast",
            }
        case 51:
        case 53:
        case 55:
            return {
                icon: "weather-showers-symbolic",
                name: "Rain",
            }
        case 95:
        case 96:
        case 99:
            return {
                icon: "weather-storms-symbolic",
                name: "Storms",
            }
        // Need to add more
        default:
            return {
                icon: "unknown",
                name: "Unknown",
            }
    } 
}

// Weather icons
//weather-fog-symbolic
//weather-severe-alert-symbolic
//weather-showers-scattered-symbolic
//weather-showers-symbolic
//weather-snow-symbolic
//weather-storm-symbolic
//weather-tornado-symbolic
//weather-windy-symbolic

// Get data from api
async function getWeather(){
    // Try to make request to weather api
    try {
        // await is needed to wait for the return of the data
        const data = await Utils.fetch(url)
            .then(res => res.json())
            //.catch(console.error)
        return data
    }

    // If request fails
    catch{
        return null
    }
}

export const weather = Variable(null, {
    poll: [400000, () => { return getWeather() }]
})

// Current temp
export const currentTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return Math.round(weather.current.temperature_2m).toString() + weather.current_units.temperature_2m.toString()
    }
    else{
        return "0"
    }
}) 

// Hi temp
export const hiTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return "hi: " + weather.daily.temperature_2m_max[0].toString() + weather.current_units.temperature_2m.toString()
    }
    else{
        return "0"
    }
}) 

// Lo temp
export const loTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return "lo: " + weather.daily.temperature_2m_min[0].toString() + weather.current_units.temperature_2m.toString()
    }
    else{
        return "0"
    }
}) 

// status
export const weatherStatus = Utils.derive([weather], (weather) => {
    if (weather != null){
        return LookupWeatherCode(weather.current.weather_code, "name").name
    }
    else{
        return "0"
    }
}) 

// Icon
export const weatherIcon = Utils.derive([weather], (weather) => {
    if (weather != null){
        print("weather code" + weather.current.weather_code)
        return LookupWeatherCode(weather.current.weather_code).icon
    }
    else{
        return "action-unavailable-symbolic"
    }
}) 

// Precipitation
export const precipitation = Utils.derive([weather], (weather) => {
    if (weather != null){
        return " " + weather.current.precipitation.toString() + "%"
    }
    else{
        return "0"
    }
}) 

// Humidity
export const humidity = Utils.derive([weather], (weather) => {
    if (weather != null){
        return " " + weather.current.relative_humidity_2m.toString() + "%"
    }
    else{
        return "0"
    }
}) 


export const Weather = (w, h) => Widget.Box({
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    children: [
        // Background image
        Widget.Box({
            class_name: "control-panel-button",
            children: [
                // Information container
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
                                    label: currentTemp.bind()
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
                                            label: hiTemp.bind(),
                                        }),
                                        // Lo
                                        Widget.Label({
                                            hpack: "start",
                                            label: loTemp.bind(),
                                        }),

                                    ]
                                })
                            ]
                        }),
                        // Status
                        Widget.Box({
                            hexpand: true,
                            hpack: "center",
                            spacing: 8,
                            children: [
                                Widget.Icon({
                                    size: 24,
                                    icon: weatherIcon.bind(),
                                }),
                                Widget.Label({
                                    label: weatherStatus.bind()
                                }),
                            ],
                        }),
                        Widget.Box({
                            children: [
                                // Precipitation
                                Widget.Label({
                                    hexpand: true,
                                    label: precipitation.bind()
                                }),
                                // Humidity
                                Widget.Label({
                                    hexpand: true,
                                    label: humidity.bind()
                                }),
                            ]
                        }),
                    ]
                })
            ],
        }).hook(weatherStatus, self => {
            // Update weather widget background based on current weather status
            /*
            self.css = `
                background-image: url("${App.configDir}/assets/${weatherStatus.value}.jpg");
            `;
            */
        }, "changed"),
    ]
})
