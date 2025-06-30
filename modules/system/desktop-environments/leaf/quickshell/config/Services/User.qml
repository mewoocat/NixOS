pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import '../' as Root

Singleton {
    id: root

    Process {
        id: usernameProc
        command: ["sh", "-c", "whoami"]
        running: true
        stdout: SplitParser { onRead: output => root.username = output}
    }
    
    // Needs the file prefix to refer to absolute path
    property string pfpPath: "file://" + Root.State.config.pfpImage
    property string username: "???"
}    
