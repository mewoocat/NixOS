pragma Singleton

import Quickshell
import Quickshell.Io
import qs.Services as Services
import qs as Root

Singleton {
    // Used to initialize this singleton
    function initialize(){
        console.log("Initializing Controller singleton")
    }
    IpcHandler {
        target: "control"

        function toggleLauncher() {
            Root.State.launcherActive = !Root.State.launcherActive
        }
        function toggleActivityCenter() {
            Root.State.activityCenterActive = !Root.State.activityCenterActive
        }
        function toggleControlPanel() {
            Root.State.controlPanelActive = !Root.State.controlPanelActive
        }
        function lockScreen() { 
            Root.State.screenLocked = true 
        }
        // Signals that the recording as actually started and wasn't canceled by the user
        function recordingStarted() { Services.ScreenCapture.recording = true }
        // Stops the recording
        function stopRecording() { Services.ScreenCapture.stopRecording() }
    }
}
