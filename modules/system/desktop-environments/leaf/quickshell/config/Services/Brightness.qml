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
        // If the values have been set
        if (root.ready) {
            brightnessFile.watchChanges = false
            brightnessSet.running = true
        }
    }
    
    // Updates the value whenever the brightness file changes
    FileView {
        id: brightnessFile
        preload: false // Waits, which allows for the path to be calculated before accessing the file
        //printErrors: false
        path: root.brightnessPath
        watchChanges: false
        onLoadFailed: (err) => {
            console.error(err)
        }
        onFileChanged: () => {
            brightnessFile.reload()
            brightnessGet.running = true
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
                //console.log("backlight device name: " + data)
                root.deviceName = data
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
                root.max = data
                root.ready = true
                brightnessGet.running = true
                brightnessFile.watchChanges = true
            }
        }
    }

    Process {
        id: brightnessSet
        onStarted: () => {}
        command: ["brightnessctl", "set", `${Math.round(root.value * root.max)}`]
        running: false
        onExited: (code, status) => {
            brightnessFile.watchChanges = true
            running = false
            //console.log(`exited with code ${code} and status ${status}`)
        }
    }

    Process {
        id: brightnessGet
        command: ["brightnessctl", "get"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                root.ready = false
                root.value = data / root.max
                root.ready = true
            }
        }
    }


}
