pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs as Root

Singleton {
    id: root

    property real latitude: Root.State.config.location.latitude
    property real longitude: Root.State.config.location.longitude

    property QtObject current: QtObject {
        property real temperature_2m: 0
        property real apparent_temperature: 0
        property real precipitation: 0
        property int weather_code: 0
        property real relative_humidity_2m: 0
    }
    
    property QtObject daily: QtObject {
        property list<string> time: []
        property list<real> temperature_2m_max: []
        property list<real> temperature_2m_min: []
    }

    function enable(){
        console.log("Enabling Weather service")
    }

    Process {
        id: weatherProc
        // For some reason when curling this url, we need to pipe it into jq to get an output
        // Update: not needed anymore since a fix was made in quickshell
        //command: ["sh", "-c", "curl 'https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch' | jq -c"]
        command: ["sh", "-c", `curl 'https://api.open-meteo.com/v1/forecast?latitude=${root.latitude}&longitude=${root.longitude}&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch'`]
        running: true
        stdout: SplitParser {
            onRead: data => {
                //console.log("data: " + data)
                const jsonData = JSON.parse(data)
                //console.log(jsonData)

                root.current.temperature_2m = Math.round(jsonData.current.temperature_2m)
                root.current.apparent_temperature = jsonData.current.apparent_temperature
                root.current.precipitation = jsonData.current.precipitation
                root.current.weather_code = jsonData.current.weather_code
                root.current.relative_humidity_2m = jsonData.current.relative_humidity_2m

                root.daily.time = jsonData.daily.time
                root.daily.temperature_2m_max = jsonData.daily.temperature_2m_max.map(v => Math.round(v))
                root.daily.temperature_2m_min = jsonData.daily.temperature_2m_min.map(v => Math.round(v))
            }
        }
    }

    Timer {
        interval: 30000 // 30 sec
        // Start the timer immediately
        running: true
        // Run the timer again when it ends
        repeat: true
        // When the timer is triggered, set the running property
        // process to true, which reruns it if stopped
        onTriggered: {
            weatherProc.running = false
            weatherProc.running = true
        }
    }

    /*
    function generateUrl() {
        const lat = location.latitude
        const lon = location.longitude
        const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch`    
        return url
    }
    */

    // Weather status code lookup
    function lookupCode(code) {

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
            case 71:
            case 73:
            case 75:
                return {
                    icon: "weather-snow-symbolic",
                    image: "weather-snow",
                    name: "Snow",
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
                console.error(`Weather code: ${code} not recognized.`)
                return {
                    icon: "Unknown",
                    name: "Unknown",
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
    }

}
