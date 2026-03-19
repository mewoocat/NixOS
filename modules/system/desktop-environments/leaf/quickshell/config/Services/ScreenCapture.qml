
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services as Services

Singleton {
    id: root

    property bool recording: false
    onRecordingChanged: console.debug(`recording set to ${recording}`)

    function toggleRecording() {
        if (root.recording){
            stopRecording()
            root.recording = false
        }
        else {
            startRecording()
            // TODO: Might want to disable the HyprlandFocusGrab when slurp is active (as to not auto close the control panel on recording start)
        }
    }

    function startRecording() {
        Quickshell.execDetached([`${Quickshell.shellDir}/Scripts/ScreenCapture.sh`])
    }

    // By default the pkill command sends the SIGTERM signal
    function stopRecording() {
        Quickshell.execDetached(["sh", "-c", "pkill -f ScreenCapture.sh"])
    }

    // Check whether or not a recording is currently occuring on shell startup
    Process {
        id: recordingCheckProc
        running: true
        command: ["sh", "-c", "pidof wf-recorder"] // TODO: Check script instead?
        onExited: (exitCode, exitStatus) => {
            if (exitCode == 0) {
                root.recording = true
            } else {
                root.recording = false
            }
        }
    }
}
