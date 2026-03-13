
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool recording: false

    function toggleRecording()
    {
        //Quickshell.execDetached(["sh", "-c", "slurp"]) // THIS WORKS
        if (root.recording){
            console.debug('rec off')
            root.recording = false
        }
        else {
            root.recording = true
            console.debug('rec on')
        }
    }

    Process {
        id: proc
        command: [`./Scripts/ScreenCapture.sh`]
        running: root.recording        
        onExited: (exitCode, existStatus) => {
            if (exitCode != 0)
            {
                Quickshell.execDetached(["sh", "-c", 'notify-send "Screen Recording Error"'])
                console.log(`Screen capture script stopped with exit code ${exitCode} and exit status ${existStatus}`)
            }
        }
        stdout: SplitParser {
            onRead: (data) => console.log(`ScreenRecorder.sh: ${data}`)
        }
        stderr: SplitParser {
            onRead: (data) => console.error(`ScreenRecorder.sh: ${data}`)
        }
    }
}