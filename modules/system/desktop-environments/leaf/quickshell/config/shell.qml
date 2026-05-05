//// Needed to enable QT_QUICK_CONTROLS_STYLE and QT_STYLE_OVERRIDE
////@ pragma RespectSystemStyle 
//// Allows for Quickshell to use styles from global QT style
////@ pragma UseQApplication
////@ pragma Env QT_QUICK_CONTROLS_STYLE=org.kde.desktop
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Material
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Imagine
////@ pragma Env QT_QUICK_CONTROLS_STYLE=Universal
////@ pragma DropExpensiveFonts
import Quickshell
import QtQuick
import "Windows/ActivityCenter"
import "Windows/Settings"
import "Windows/OnScreenDisplay"
import "Windows/Bar"
import "Windows/Launcher"
import "Windows/ControlPanel"
import "Windows/Notifications"
import "Windows/Lockscreen"
import "Windows"

ShellRoot {
    Component.onCompleted: {
        Controller.initialize() // Needed for ipc to find target
    }
    Bar {}
    ControlPanel {}
    Launcher {}
    Notifications {}
    ActivityCenter {}
    Lockscreen {}
}
