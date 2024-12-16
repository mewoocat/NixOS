import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Gtk from 'gi://Gtk'
import GObject from 'gi://GObject'

import * as Options from '../Options/options.js'

print("INFO: Entered Weather.js <----------------")

///////////////////////////////////
//  Weather setup
///////////////////////////////////
export const weather = Variable(null, {
    poll: [40000, () => { 
        return getWeather()
    }]
})
/*
weather.stopPoll()
setTimeout(() => {
        print("INFO: Connecting to isJsonLoaded")
        Options.isJsonLoaded.connect('changed', ({value}) => {
            print(`INFO: isJsonLoaded: ${value}`)
            if (value){
                weather.startPoll()
            }
        })
    },
    5000
)
*/

// Get data from apr
async function getWeather(){
    print("INFO: Getting weather data from internet")

    // Get user lat lon
    //TODO add variables for units
    if (Options.data != null){
        var lat = Options.data.lat
        var lon = Options.data.lon
    }
    else{
        print("ERROR: Invalid weather lat/lon.  Defaulting to 0,0")
        var lat = 0
        var lon = 0
    }

    // Try to make request to weather api
    try {
        var url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch`    
        // await is needed to wait for the return of the data
        const weatherData = await Utils.fetch(url)
            .then(res => res.json())
            //.catch(console.error)
        return weatherData
    }

    // If request fails
    catch{
        return null
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////
// City Lookup to Lat/Lon Widget
/////////////////////////////////////////////////////////////////////////////////////////////

// Get lat and lon from city
// Get data from api
async function getCord(cityName){
    // Encode the city name search to replace spaces with +'s 
    // The web api seems to require the spaces in the query to be + not %20
    //const cityNameEncoded = cityName.split(' ').join('+')
    let urlBase = `https://geocoding-api.open-meteo.com/v1/search`
    let query = `?name=${cityName}&count=5&language=en&format=json`
    query = query.split(' ').join('+')
    let url = urlBase + query
    print(`INFO: URL: ${url}`)

    // Test 
    /*
    const test = "string with spaces"
    print(test.split(' ').join('+'))
    const test2 = `?name=${test}&count=5&language=en&format=json`
    print(test2.split(' ').join('+'))
    */

    // Try to make request to weather api
    try {
        // await is needed to wait for the return of the data
        const data = await Utils.fetch(url)
            .then(res => res.json())
            //.then(res => res.text())
            .catch(err => print(err))
        //print(JSON.stringify(data, null, 4))
        return data
    }

    // If request fails
    catch{
        return null
    }
}

async function updateCities(text){ 
    //let cities = ["london", "new york", "tokyo"] 
    try{
        let data = await getCord(text)
        //let cities = data.results.map(city => city.name.toString())
        searchResults.value = data.results
    }
    catch(err){
        print(err)
    }
}


const searchResults = Variable([])
const locationData = Variable({})

function SelectedLocation(){

    // Update json settings data with new location
    Options.data.lat = locationData.value.latitude
    Options.data.lon = locationData.value.longitude
    Options.WriteOutSettingsFile()

    // Refresh the weather
    weather.stopPoll()
    weather.startPoll()
    /*
    const updatedWeather = getWeather()
    print(JSON.stringify(updatedWeather))
    weather.setValue(updatedWeather)
    */
}

export const locationSearch = Widget.Entry({
    placeholder_text: "Enter city",
    on_change: self => {
        updateCities(self.text).catch(err => print(err))
    },
    on_accept: (self) => {
        // Probably should do nothing when accepted and fully rely on the match-selected signal
        // Hmmm... maybe not?

        const [matched, iter] = listStore.get_iter_first() // Get the first suggestion
        self.text = listStore.get_value(iter, 0) // Set the text of the entry to the first suggestion
        locationData.value = listStore.get_value(iter, 1) // Retrive the value associated with the first suggestion
        completion.popup_completion = true
        

        print("Entered.. ")
        //print(locationData.value.city)
        print(locationData.value.latitude)
        print(locationData.value.longitude)

        SelectedLocation()
    },
    setup: (self) => {
        self.placeholder_text = "Enter location..."
    },
}).hook(searchResults, self => {
    listStore.clear()
    const cities = searchResults.value
    for (const city of cities) {
        print(city.name.toString()) 
        const iter = listStore.append()
        const cityText = city.name.toString() + ": " + (city.admin1 ?? " ").toString() + " " + city.country_code.toString()
        listStore.set(iter, [0, 1], [cityText, city]);
    }
    completion.set_model(listStore)
    completion.complete()
    self.set_completion(completion)
}, "changed")


const listStore = new Gtk.ListStore()
listStore.set_column_types([GObject.TYPE_STRING, GObject.TYPE_JSOBJECT]);

const completion = new Gtk.EntryCompletion();
completion.set_text_column(0) // Column of the model to use for text
completion.inline_completion = true
completion.inline_selection = false
completion.popup_set_width = true
completion.set_match_func(() => true) // Match all rows in model
                                      // This delegates all filtering functionality to the location API

// Whenever a match in the completion popup is selected
// match-selected(entryCompletion, model, iter) 
completion.connect("match-selected", (completion, model, iter) =>{
    completion.get_entry().text = listStore.get_value(iter, 0) // Set the entry text to the completed text
    locationData.value = listStore.get_value(iter, 1) // Retrive the value associated with the completed text

    print("Entered..  via match-selected")
    print(locationData.value.latitude)
    print(locationData.value.longitude)

    SelectedLocation()
})



/////////////////////////////////////////////////////////////////////////////////////////////
// Weather status code lookup
/////////////////////////////////////////////////////////////////////////////////////////////

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
    let mode = ""
    var currentHour = new Date().getHours()
    // If night
    if (currentHour >= 18 || currentHour < 6){
        mode="-night"
    }
    // Else day
    else{
        mode=""
    }

    switch(code) {
        case 0:
            return {
                icon: `weather-clear${mode}-symbolic`, // "weather-clear-night-symbolic"
                image: `weather-clear${mode}`,
                name: "Clear sky",
            }
        case 1:
            return {
                icon: `weather-few-clouds${mode}-symbolic`, // "weather-few-clouds-symbolic"
                image: `weather-few-clouds${mode}`,
                name: "Mostly clear",
            }
        case 2:
            return {
                icon: `weather-few-clouds${mode}-symbolic`, // "weather-few-clouds-symbolic"
                image: `weather-partly-cloudy${mode}`,
                name: "Partly cloudy",
            }
        case 3:
            return {
                icon: `weather-overcast-symbolic`,
                image: `weather-overcast`,
                name: "Overcast",
            }
        case 45:
        case 48:
            return {
                icon: "weather-fog-symbolic",
                image: "weather-fog",
                name: "Fog",
            }
        case 51:
        case 53:
        case 55:
        case 61:
        case 63:
        case 65:
        case 80:
        case 81:
        case 82:
            return {
                icon: "weather-showers-symbolic",
                image: "weather-showers",
                name: "Rain",
            }
        case 95:
        case 96:
        case 99:
            return {
                icon: "weather-storms-symbolic",
                image: "weather-storms",
                name: "Storms",
            }
        // Need to add more
        default:
            //print(`Weather code ${code} not recognized.`)
            return {
                icon: "Unknown",
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


// Current temp
export const currentTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return Math.round(weather.current.temperature_2m).toString() /* weather.current_units.temperature_2m.toString()*/ + "°"
    }
    else{
        return "0"
    }
}) 

// Hi temp
export const hiTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return "hi: " + Math.round(weather.daily.temperature_2m_max[0]).toString() + weather.current_units.temperature_2m.toString()
    }
    else{
        return "0"
    }
}) 

// Lo temp
export const loTemp = Utils.derive([weather], (weather) => {
    if (weather != null){
        return "lo: " + Math.round(weather.daily.temperature_2m_min[0]).toString() + weather.current_units.temperature_2m.toString()
    }
    else{
        return "0"
    }
}) 

// status
export const weatherStatus = Utils.derive([weather], (weather) => {
    if (weather != null){
        return LookupWeatherCode(weather.current.weather_code).name
    }
    else{
        return "0"
    }
}) 

// Image
export const weatherImage = Utils.derive([weather], (weather) => {
    if (weather != null){
        //print("weather image = " + LookupWeatherCode(weather.current.weather_code).image)
        return LookupWeatherCode(weather.current.weather_code).image
    }
    else{
        return "Unknown"
    }
}) 

// Icon
export const weatherIcon = Utils.derive([weather], (weather) => {
    if (weather != null){
        //print("weather code" + weather.current.weather_code)
        return LookupWeatherCode(weather.current.weather_code).icon
    }
    else{
        return "action-unavailable-symbolic"
    }
}) 

// Precipitation
export const precipitation = Utils.derive([weather], (weather) => {
    if (weather != null){
        return Math.round(weather.current.precipitation).toString() + "%"
    }
    else{
        return "0"
    }
}) 

// Humidity
export const humidity = Utils.derive([weather], (weather) => {
    if (weather != null){
        return Math.round(weather.current.relative_humidity_2m).toString() + "%"
    }
    else{
        return "0"
    }
}) 


export const Weather = () => Widget.Box({
    vertical: true,
    hexpand: true,
    //class_name: "weather-container", // Background image
    css: `
        padding: 1.4em;
    `,
    spacing: 8,
    children: [

        // Icon and Temp
        Widget.Box({
            spacing: 12,
            hpack: "start",
            children:[
                // Status icon
                Widget.Icon({
                    size: 40,
                    icon: weatherIcon.bind(),
                }),
                // Current temp
                Widget.Label({
                    hexpand: true,
                    css: `
                        font-size: 2.2rem;
                    `,
                    label: currentTemp.bind()
                }),
            ]
        }),
        // Status
        Widget.Box({
            hexpand: true,
            hpack: "start",
            spacing: 8,
            children: [
                Widget.Label({
                    label: weatherStatus.bind()
                }),
            ],
        }),

        // Hi and low temps
        Widget.Box({
            vertical: true,
            hexpand: true,
            vpack: "end",
            vexpand: true,
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
        }),
        
        // Precipitation and humidity
        /*
        Widget.Box({
            hexpand: true,
            children: [
                Widget.Box({
                    spacing: 16,
                    hpack: "center",
                    children: [
                        // Precipitation
                        Widget.Box({
                            spacing: 4,
                            tooltip_text: "Precipitation",
                            children: [
                                Widget.Icon({
                                    size: 18,
                                    icon: "weather-showers-symbolic",
                                }),
                                Widget.Label({
                                    hexpand: true,
                                    label: precipitation.bind()
                                }),
                            ],
                        }),
                        // Humidity
                        Widget.Box({
                            spacing: 4,
                            tooltip_text: "Humidity",
                            children: [
                                Widget.Icon({
                                    size: 18,
                                    icon: "raindrop",
                                }),
                                Widget.Label({
                                    hexpand: true,
                                    label: humidity.bind()
                                }),
                            ],
                        })
                    ]
                }),
            ],
        }),
        */
    ]
}).hook(weatherImage, self => {
    // Update weather widget background based on current weather status
    /*
    print("image "+weatherImage.value)
    self.css = `
        background-image: url("${App.configDir}/assets/${weatherImage.value}.jpg"); 
        background-position: center;
        background-size: cover;
    `;
    */
}, "changed")


