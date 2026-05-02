pragma Singleton

import Quickshell
import Quickshell.Io
import qs.Services as Services

Singleton {
    // Used to initialize this singleton
    function initialize(){
        console.log("Initializing Controller singleton")
    }
    IpcHandler {
        target: "control"

        function toggleLauncher() {
            State.launcher.toggleWindow()
        }
        function toggleActivityCenter() {
            State.activityCenter.toggleWindow()
        }
        function toggleControlPanel() {
            State.controlPanel.toggleWindow()
        }
        function toggleWorkspaces() {
            State.workspaces.toggleWindow()
        }
        function lockScreen() { 
            console.log(`locked pre = ${State.screenLocked}`)
            State.screenLocked = true 
            console.log(`locked post = ${State.screenLocked}`)
        }
        // Signals that the recording as actually started and wasn't canceled by the user
        function recordingStarted() { Services.ScreenCapture.recording = true }
        // Stops the recording
        function stopRecording() { Services.ScreenCapture.stopRecording() }
    }
}
