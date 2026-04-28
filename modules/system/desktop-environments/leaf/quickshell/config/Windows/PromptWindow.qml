pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

Shared.PanelWindow {
    id: root
    name: "prompt"

    property bool active: Root.State.promptStack.length != 0
    visible: active
    color: "transparent"
    focusable: true
    content: Loader {
        id: contentLoader
        active: root.active
        onActiveChanged: console.debug(`active: ${active}`)
        //sourceComponent: Root.State.promptStack[Root.State.promptStack.length - 1]
        sourceComponent: Root.State.promptStack[0]
        Component.onCompleted: console.debug(`sourceComponent: ${sourceComponent}`)
        onSourceComponentChanged: console.debug(`sourceComponent: ${sourceComponent}`)
    }
}
