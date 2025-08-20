import QtQuick.Controls
import qs as Root
import qs.Services as Services

Option {
    content: TextField {
        onAccepted: {
            console.log("what")
            //Root.State.config.workspaces.wsList[0].name = text
            //Root.State.config.workspaces.wsList = ["what"]
            //Root.State.configFileView.writeAdapter()
            //Services.Hyprland.setWsName(text)
            Services.Hyprland.applyWsConf()
        }
    }
}
