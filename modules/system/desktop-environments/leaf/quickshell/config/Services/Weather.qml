pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property QtObject location: QtObject {
        property real latitude: 0
        property real longitude: 0
    }
    property string url: generateUrl()
    onLocationChanged: () => {
        root.url = generateUrl()
    }
    
    function enable(){
        console.log("Enabling Weather service")
    }

    function generateUrl() {
        const lat = location.latitude
        const lon = location.longitude
        const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch`    
        return url
    }

    Process {
        id: weatherProc
        // For some reason when curling this url, we need to pipe it into jq to get an output
        command: ["sh", "-c", "curl 'https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch' | jq -c"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                console.log("data: " + data)
                const jsonData = JSON.parse(data)
                console.log(jsonData)
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
}
