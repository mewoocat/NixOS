
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool recording: false

    // A better idea might be having some ipc commands that the recording script calls to set the recording status
    function checkRecording(): bool {
        recordingCheckProc.running = true
    }

    function toggleRecording() {
        if (root.recording){
            console.debug('rec off')
            stopRecording()
            root.recording = false
        }
        else {
            root.recording = true
            startRecording()
            console.debug('rec on')
        }
    }

    function startRecording() {
        Quickshell.execDetached([`${Quickshell.shellDir}/Scripts/ScreenCapture.sh`])
    }

    function stopRecording() {
        Quickshell.execDetached(["sh", "-c", "pkill wf-recorder"])
    }

    Process {
        id: recordingCheckProc
        running: true
        command: ["sh", "-c", "pidof wf-recorder"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode == 0) {
                root.recording = true
            } else {
                root.recording = false
            }
        }
    }

    /*
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
    */
}
