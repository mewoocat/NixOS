pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

FloatingWindow {
    color: "grey"

    SequentialDragGrid {
        model: [ "red", "green", "blue" ]
        delegate: appItem
        property Component appItem: Rectangle {
            property var delegateData: null
            implicitWidth: 20
            implicitHeight: 20
            color: delegateData
            Component.onCompleted: console.log(`modelData: ${delegateData}`)
        }
    }
}
