pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs as Root

Singleton {
    id: root

    Process {
        id: usernameProc
        command: ["sh", "-c", "whoami"]
        running: true
        stdout: SplitParser { onRead: output => root.username = output}
    }
    
    // Needs the file prefix to refer to absolute path
    //property string pfpPath: Root.State.config.pfpImagePath != "" ? "file://" + Root.State.config.pfpImagePath : "wtf"
    //onPfpPathChanged: console.debug(`pfp path: ${pfpPath}`)
    //property string username: "???"
}    
