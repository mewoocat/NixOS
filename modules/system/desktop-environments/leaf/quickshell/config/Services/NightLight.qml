pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    function toggle(): void {
        process.running = !process.running
    }

    Process {
        id: process
        running: false
        command: ["sh", "-c", "wlsunset -T 4010"]
    }
}
