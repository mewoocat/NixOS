pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import '../' as Root

Singleton {
    id: root
    
    // Needs the file prefix to refer to absolute path
    //property string pfpPath: "file://" + "/home/eXia/.config/leaf-de/pfp"
    property string pfpPath: "file://" + Root.State.config.pfpImage
}    
