pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared


// This is a general purpose window used to render a prompt from the global prompt stack
Shared.PanelWindow {
    id: root
    name: "prompt"
    visible: Root.State.promptVisibility
    color: "transparent"
    focusable: true
    onCloseWindow: () => {
        Root.State.promptVisibility = false
    }
    content: Loader {
        id: contentLoader
        active: Root.State.promptStack.length != 0
        sourceComponent: Root.State.promptStack[Root.State.promptStack.length - 1]
    }
}
