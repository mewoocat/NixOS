import qs as Root

BarButton {
    onClicked: () => {
        const prevActiveState = Root.State.controlPanelActive
        Root.State.closeAll()
        Root.State.controlPanelActive = !prevActiveState
    }
    icon.name: "open-menu-symbolic"
}
