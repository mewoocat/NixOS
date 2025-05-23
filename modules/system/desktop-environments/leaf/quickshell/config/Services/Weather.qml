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
        command: ["bash", "/home/eXia/NixOS/modules/system/desktop-environments/leaf/quickshell/config/Services/weather.sh"]
        //command: ["curl", "-o", "-", "https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch"]
        //command: ["bash", "-c", "curl -o - \"https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch\""]
        //command: ["sh", "-c", "curl -o - \"https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch\""]

        //command: ["curl", "https://api.open-meteo.com/v1/forecas"]
        //command: ["sh", "-c", "curl \"https://api.open-meteo.com/v1/forecast\?latitude=0\&longitude=0\&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m\&daily=temperature_2m_max,temperature_2m_min\&temperature_unit=fahrenheit\&wind_speed_unit=ms&precipitation_unit=inch\""]
        //command: ["bash", "-c", "curl \"https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch\""]
        //command: ["bash", "-c", "curl \"https://api.open-meteo.com/v1/forecast?latitude=0\&longitude=0\&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m\&daily=temperature_2m_max,temperature_2m_min\&temperature_unit=fahrenheit\&wind_speed_unit=ms\&precipitation_unit=inch\""]
        //command: ["bash", "-c", "curl https://api.open-meteo.com/v1/forecast?latitude=0\&longitude=0\&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m\&daily=temperature_2m_max,temperature_2m_min\&temperature_unit=fahrenheit\&wind_speed_unit=ms\&precipitation_unit=inch"]
        //command: ["curl", "https://api.open-meteo.com/v1/forecast?latitude=0\&longitude=0\&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m\&daily=temperature_2m_max,temperature_2m_min\&temperature_unit=fahrenheit\&wind_speed_unit=ms\&precipitation_unit=inch"]
        //command: ["curl", "https://api.open-meteo.com/v1/forecast?latitude=0"]
        //command: ["bash", "-c", "curl https://quickshell.outfoxxed.me?"]
        running: false
        onExited: (exitCode, exitStatus) => {
            console.error(exitCode)
            console.error(exitStatus)
        }
        onStarted: () => {
            console.log("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")
        }
        stdout: SplitParser {
            onRead: data => {
                console.log("data: " + data)
            }
        }
        stderr: SplitParser {
            onRead: data => {
                console.error(data)
            }
        }
    }

    Timer {
        interval: 5000
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
