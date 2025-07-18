pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    Process { id: shutdownProc; command: ["sh", "-c", "shutdown now"]; }
    Process { id: restartProc; command: ["sh", "-c", "systemctl reboot"]; }
    Process { id: hibernateProc; command: ["sh", "-c", "systemctl hibernate"]; }
    Process { id: sleepProc; command: ["sh", "-c", "systemctl suspend"]; }

    function shutdown() {
        //shutdownProc.startDetached() // I think i need to update qs
        shutdownProc.running = true
    }
    function restart() { restartProc.running = true }
    function hibernate() { hibernateProc.running = true }
    function sleep() { sleepProc.running = true }

    property var currentProfile: PowerProfiles.profile

}
