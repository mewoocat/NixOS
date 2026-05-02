import qs as Root

BarButton {
    onClicked: () => Root.State.launcherActive = !Root.State.launcherActive
    icon.name: Root.State.launcherIcon
    //isMutliColorIcon: true
}
