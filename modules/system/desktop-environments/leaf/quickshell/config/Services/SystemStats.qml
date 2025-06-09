pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    
    property real cpuUsage: 0
    property real memUsage: 0
    property string memUsageText: ""
    property real storageUsage: 0
    property string storageUsageText: ""
    property string storageDrive: "/" // Defaults to root
    
    Process {
        id: cpuUsageProc
        // Todo: optimize
        command: ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.cpuUsage = data
            }
        }
    }

    Process {
        id: memUsageProc
        // Todo: optimize
        command: ["free", "--kibi"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                // Ignore irrelevant lines
                if (!line.includes('Mem:')) {
                    return
                }
                const GBinKiB = 0.000001024
                const memArray = line
                    .split('\n')  // idk why this works since it should be iterating over everylien with the SplitParser?
                    .find(line => line.includes('Mem:'))
                    .split(/\s+/)
                const total = Math.round(memArray[1] * GBinKiB * 10) / 10 // Round to 1 decimal place
                const used = Math.round(memArray[2] * GBinKiB * 10 ) / 10 // Round to 1 decimal place  

                root.memUsage = Math.round((used / total) * 100) // 0 -> 100
                root.memUsageText = `Usage: ${used} GB / ${total} GB`
            }
        }
    }
    //    poll: [6000, ['bash', '-c', "fastfetch --packages-disabled nix --logo none --cpu-temp | grep 'CPU:' | rev | cut -d ' ' -f1 | cut -c 4- | rev"], out => Math.round(out)


    Process {
        id: storageUsageProc
        // Todo: optimize
        command: ["df", root.storageDrive]
        //command: ["whoami"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                // If the line doesn't end with the drive we are querying for
                if (!data.endsWith(root.storageDrive)) {
                    return
                }
                const storageArray = data.split(/\s+/) // Split on spaces
                let total = storageArray[1]
                let available = storageArray[3]
                let used = total - available
                let usage = Math.round(used / total * 100000) / 100000 // Round to 5 decimal places
                usage = usage * 100 // 0 -> 100
                
                const GBinKiB = 0.000001024
                total = Math.round(storageArray[1] * GBinKiB * 10) / 10 // Round to 1 decimal place
                available = Math.round(storageArray[3] * GBinKiB * 10) / 10 // Round to 1 decimal place
                used = Math.round((total - available) * 10) / 10 // Round to 1 decimal place
                const storageFormatted = `Usage of /: ${used} GB / ${total} GB`

                root.storageUsage = usage
                root.storageUsageText = storageFormatted
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        // Rerun the processes
        onTriggered: {
            cpuUsageProc.running = true
            memUsageProc.running = true
            storageUsageProc.running = true
        }
    }
}
