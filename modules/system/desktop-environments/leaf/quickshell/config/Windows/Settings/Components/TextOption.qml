import QtQuick.Controls
import "../../../" as Root
import "../../../Services" as Services

Option {
    content: TextField {
        onAccepted: {
            console.log("what")
            //Root.State.config.workspaces.wsList[0].name = text
            //Root.State.config.workspaces.wsList = ["what"]
            Root.State.configFileView.writeAdapter()
            Services.Hyprland.applyWsConf()
        }
    }
}
