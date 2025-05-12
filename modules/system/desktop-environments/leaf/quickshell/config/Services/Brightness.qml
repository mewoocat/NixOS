pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property int min: 0
    property real value: 0 // 0 -> 1
    property int max: 0
    property string deviceName: ""
    property string brightnessPath: `/sys/class/backlight/${root.deviceName}/brightness`
    property bool ready: false

    function enable(){
        console.log("Enabling brightness service")
    }

    onValueChanged: () => {
        console.log(`Brightness.value changed: ${root.value}`)
        // If the values have been set
        if (root.ready) {
            console.log(`Setting brightness to ${Math.round(root.value * root.max)}`)
            //brightnessSet.running = false
            brightnessFile.watchChanges = false
            brightnessSet.running = true
            //brightnessSet.startDetached()
            brightnessFile.watchChanges = true
        }
    }
    
    // Updates the value whenever the brightness file changes
    FileView {
        id: brightnessFile
        path: root.brightnessPath
        watchChanges: false
        onFileChanged: () => {
            brightnessFile.reload()
            console.log("Brightness file changed: text: " + brightnessFile.text())
            //brightnessGet.running = false
            brightnessGet.running = true
            //console.log("brightnessFile.text(): " + brightnessFile.text())
            //root.value = brightnessFile.text() / root.max
        }
    }
    
    Process {
        // An ID to refer to this with
        id: brightnessProcess
        // The command to run, every argument is it's own string
        command: ["ls", "-w1", "/sys/class/backlight", "|", "head", "-1"]
        // Run the command immediately
        running: true
        // Process the stdout stream using a SplitParser
        // which returns chunks of output after a delimiter
        stdout: SplitParser {
            // Listen for the read signal, which returns the data
            // that was read from stdout
            onRead: data => {
                console.log("backlight device name: " + data)
                deviceName = data
                brightnessMax.running = true
            }
        }
    }

    // Get brightness max
    Process {
        id: brightnessMax
        command: ["brightnessctl", "max"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                console.log("backlight max: " + data)
                root.max = data
                root.ready = true
                brightnessGet.running = true
                brightnessFile.watchChanges = true
            }
        }
    }

    Process {
        id: brightnessSet
        onStarted: () => {
            //console.log(`${Math.round(root.value * root.max)}`)
        }
        command: ["brightnessctl", "set", `${Math.round(root.value * root.max)}`]
        //command: ["pkill", "brightnessctl", "&&", "brightnessctl", "set", "+10"]
        //command: ["brightnessctl", "set", "+10"]
        //command: ["echo", "test"]
        running: false
        onExited: (code, status) => {
            running = false
            console.log(`exited with code ${code} and status ${status}`)
        }
    }

    Process {
        id: brightnessGet
        command: ["brightnessctl", "get"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                console.log("brightnessctl get: " + data)
                root.ready = false
                root.value = data / root.max
                root.ready = true
            }
        }
    }


}
