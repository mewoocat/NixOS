import QtQuick
import "root:/Singletons" as Sin
import "root:/Modules/Ui" as Ui
import "root:/" as Root

Ui.NormalButton {
    //implicitWidth: child.width
    //height: 500
    //Layout.fillHeight: true
    action: () => Root.State.activityCenter.toggleWindow()
    iconName: "security-low"
    text: Sin.Time.time
}
