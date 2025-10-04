import Quickshell
import qs as Root

SidePanelItem {
    onClicked: {
        Root.State.settings.openWindow()
        Root.State.launcher.closeWindow()
    }
    imgName: 'application-menu-symbolic'
    imgSize: 24
}
