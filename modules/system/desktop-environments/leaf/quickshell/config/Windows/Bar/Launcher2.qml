import qs as Root

BarButton {
    onClicked: () => {
        Root.State.closeAll();
        Root.State.windows.launcher2.toggleWindow();
    }
    icon.name: "ball"
    //isMutliColorIcon: true
}
