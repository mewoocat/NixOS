import Quickshell
import QtQuick.Layouts
import "../../Modules/Common" as Common

Common.PopupWindow {
    name: "notifications"
    visible: false
    anchors {
        top: true
    }
    implicitWidth: 400
    implicitHeight: 300

    // TODO: Add new notifications for a limited period of time (osd)
    ColumnLayout {
    }
}
