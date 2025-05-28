import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/" as Root
import "root:/Modules" as Modules
import "root:/Modules/Common" as Common
import "root:/Services" as Services

import Quickshell.Services.Notifications

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
