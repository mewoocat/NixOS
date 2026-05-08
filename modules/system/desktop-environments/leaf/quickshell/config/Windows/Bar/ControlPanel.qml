import qs as Root

BarButton {
    onClicked: () => {
        const prevActiveState = Root.State.controlPanelActive
        Root.State.closeAll()
        Root.State.controlPanelActive = !prevActiveState
    }
    // NOTE: This particular icon ("open-menu-symbolic", breeze) has multiple sizes
    // that look slightly different.  And since QT will pick the size closest to the 
    // desired size, it seems that display scaling can cause a diferent size and thus
    // look depending on the display scale.
    icon.name: "open-menu-symbolic"
}
