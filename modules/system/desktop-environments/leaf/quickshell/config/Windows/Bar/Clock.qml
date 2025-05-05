import QtQuick
import "root:/Singletons" as Sin
import "root:/Modules/Ui" as Ui

Ui.NormalButton {
    action: () => console.log("what")
    text: Sin.Time.time
}
