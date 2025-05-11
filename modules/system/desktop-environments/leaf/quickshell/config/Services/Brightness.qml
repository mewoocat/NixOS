pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    function enable(){
        console.log("Enabling brightness service")
    }
    property string deviceName: ""
    property int min: 0
    property real value: 0 // 0 -> 1
    property int max: 0
    property string brightnessPath: `/sys/class/backlight/${root.deviceName}/brightness`

    onValueChanged: () => {
        console.log(`value changed: ${root.value}`)
        brightnessSet.running = false
    }
    /*
    function update(value) {
        root.value = value
        //brightnessSet.running = false // Stop a running instance
    }
    */
    
    // Updates the value whenever the brightness file changes
    FileView {
        id: brightnessFile
        path: root.brightnessPath
        watchChanges: true
        onFileChanged: () => {
            //brightnessFile.reload()
            //brightnessGet.running = false
            brightnessGet.running = true
            //console.log("brightnessFile.text(): " + brightnessFile.text())
            //root.value = brightnessFile.text() / root.max
            console.log(`brightness change value: ${root.value}`)
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
                console.log("backlight dev: " + data)
                deviceName = data
            }
        }
    }

    // Get brightness max
    Process {
        command: ["brightnessctl", "max"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                console.log("backlight max: " + data)
                max = data
            }
        }
    }

    // 
    Process {
        id: brightnessSet
        command: ["brightnessctl", "set", root.value * root.max]
        running: false
    }

    Process {
        id: brightnessGet
        command: ["brightnessctl", "get"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                console.log("brightnessctl get output: " + data)
                root.value = data / root.max
            }
        }
    }


}
