import Quickshell
import qs as Root
import qs.Components.Shared as Shared

Shared.PanelButton {
    onClicked: {
        Root.State.settings.openWindow()
        Root.State.launcher.closeWindow()
    }
    icon.name: 'settings-configure-symbolic'
}
