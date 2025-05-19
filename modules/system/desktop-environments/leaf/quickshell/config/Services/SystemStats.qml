pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property var cpuUsage: 0
    
    Process {
        id: cpuUsageProc
        // Todo: optimize
        command: ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"]
        //command: ["whoami"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                console.log("cpu usage: " + data)
                cpuUsage = data
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: cpuUsageProc.running = true
    }


}
