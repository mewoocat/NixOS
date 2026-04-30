//// Needed to enable QT_QUICK_CONTROLS_STYLE and QT_STYLE_OVERRIDE
////@ pragma RespectSystemStyle 
//// Allows for Quickshell to use styles from global QT style
////@ pragma UseQApplication
////@ pragma Env QT_QUICK_CONTROLS_STYLE=org.kde.desktop
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Material
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Imagine
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Universal
import Quickshell
import QtQuick
import Quickshell.Hyprland
import "Services" as Services
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"
import "Windows/ActivityCenter"
import "Windows/Workspaces"
import "Windows/Notifications"
import "Windows/Settings"
import "Windows/OnScreenDisplay"
import "Windows/Lockscreen"
import "Windows"
//import Quickshell.Services.NetworkManager

ShellRoot {
    Component.onCompleted: {
        Controller.enable() // Needed for ipc to find target
    }

    // Visual
    Bar {} 
    Launcher {}
    ControlPanel {}
    ActivityCenter {}
    Notifications {}
    //Settings {}
    Lockscreen {}
    //OnScreenDisplay {}
    //ClickAway {}
    PromptWindow {}
}
