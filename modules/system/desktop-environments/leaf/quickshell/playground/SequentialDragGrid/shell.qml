pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

FloatingWindow {
    color: "grey"

    SequentialDragGrid {
        DelegateModel {
            id: delegateModel
            model: [ "red", "green", "blue" ]
            delegate: Rectangle {
                required property var modelData
                anchors.fill: parent
                color: modelData
                Component.onCompleted: console.log(`modelData: ${modelData}`)
            }
        }
        model: delegateModel.model
        delegate: delegateModel.delegate
    }
}
