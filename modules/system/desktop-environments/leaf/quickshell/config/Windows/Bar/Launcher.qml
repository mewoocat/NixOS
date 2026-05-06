import qs as Root

BarButton {
    onClicked: () => {
        const prevActiveState = Root.State.launcherActive
        Root.State.closeAll()
        Root.State.launcherActive = !prevActiveState
    }
    icon.name: Root.State.launcherIcon
    //isMutliColorIcon: true
}
