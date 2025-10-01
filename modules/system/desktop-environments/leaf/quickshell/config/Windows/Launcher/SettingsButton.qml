import Quickshell
import qs as Root

SidePanelItem {
    onClicked: {
        Root.State.settings.openWindow()
        Root.State.launcher.closeWindow()
    }
    imgPath: Quickshell.iconPath('application-menu-symbolic')
    imgSize: 24
}
