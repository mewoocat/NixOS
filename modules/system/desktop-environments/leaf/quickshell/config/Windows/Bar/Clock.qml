import QtQuick
import QtQuick.Layouts
import "root:/Singletons" as Sin
import "root:/Modules/Ui" as Ui

Ui.NormalButton {
    //implicitWidth: child.width
    //height: 500
    Layout.fillHeight: true
    action: () => console.log("what")
    text: Sin.Time.time
}
