import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';

const divide = ([total, free]) => free / total;

export const GPUTemp = Variable(0, {
    poll: [1000, ['bash', '-c', "gpustat --no-header | grep '\[0\]' | cut -d '|' -f 2 | cut -d ',' -f 1 | cut -c -3"], out => Math.round(parseInt(out))/100]
    //poll: [1000, ['bash', '-c', ""], out => Math.round(parseInt(out))/100]
})

export const cpu = Variable(0, {
    poll: [1000, ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"], out => Math.round(out)/100]
})

export const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

// Cpu temp
export const temp = Variable(-1, {
    poll: [6000, ['bash', '-c', "fastfetch --packages-disabled nix --logo none --cpu-temp | grep 'CPU:' | rev | cut -d ' ' -f1 | cut -c 4- | rev"], out => Math.round(out)
]});

// Percent of storage used on '/' drive
//TODO -t ext4 is a workaround the "df: /run/user/1000/doc: Operation not permitted" error which is returning a non zero value which might be causing it not to work
export const storage = Variable(0, {
    poll: [5000, 'df -h -t ext4', out => out.split('\n')
        .find(line => line.endsWith("/"))
        .split(/\s+/).slice(-2)[0]
        .replace('%', '')
    ]
});


import App from 'resource:///com/github/Aylur/ags/app.js';
// Read in user settings
const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))


///////////////////////////////////
//  Weather
///////////////////////////////////

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
        return LookupWeatherCode(weather.current.weather_code)
    }
    else{
        return "0"
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

export const user = Variable("...", {
    poll: [60000, 'whoami', out => out]
});

export const uptime = Variable("...", {
    poll: [60000, 'uptime', out => out.split(',')[0]]
});


// Window states
export const isLauncherOpen = Variable(false)



