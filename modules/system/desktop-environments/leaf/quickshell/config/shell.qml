import Quickshell
import QtQuick
import Quickshell.Hyprland
import "Services" as Services
import "Windows" as Windows
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"
import "Windows/ActivityCenter"
//import Quickshell.Services.NetworkManager

ShellRoot {
    // Logic
    Component.onCompleted: {
        Controller.enable()
        Services.Hyprland.enable()
        Services.Brightness.enable()
    }

    // Visual
    Bar {} 
    Launcher {}
    ControlPanel {}
    ActivityCenter {}

    //ControlPanel.children {}
}
