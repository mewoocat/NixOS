import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../" as Root
import "../../../Services" as Services
import "../Components"

PageBase {
    id: root
    pageName: "General"
    // Note that PageBase isn't the parent of this component
    // And that the width of a ColumnLayout is determined by it's children
    content: WrapperItem {
        margin: 24
        ColumnLayout {
            implicitWidth: root.width - 24 * 2
            spacing: 24
            OptionSection {
                name: "Workspaces"
                options: [
                    Option {
                        title: "Rounding"
                        content: Switch {
                            //text: "what"
                            //contentItem: null // Remove default text element which was reserving space
                            onClicked: {
                                Services.Hyprland.selectedWorkspace.rounding = checked
                                console.log(`rounding: ${Services.Hyprland.selectedWorkspace.rounding}`)
                                Services.Hyprland.applyWsConf()
                            }
                        }
                    },
                    ComboOption {
                        title: "Workspace"
                        subtitle: "The workspace to modify"
                        options: [
                            "Workspace 1",
                            "Workspace 2",
                            "Workspace 3"
                        ]
                    },
                    TextOption {
                        title: "Name"
                        // no work/
                        /*
                        Component.onCompleted: {
                            content.onAccepted = () => {
                                console.log("accepted")
                                Root.State.config.workspaces.list[0].name = text
                            }
                        }
                        */
                    },
                    ComboOption {
                        title: "Monitor"
                        subtitle: "The monitor to assign this workspace to"
                        options: [
                            "Monitor 1",
                            "Monitor 2",
                            "Monitor 3"
                        ]
                    },
                    SpinOption {
                        title: "Outer gaps"
                    },
                    SpinOption {
                        title: "Inner gaps"
                    }
                ]
            }

            OptionSection {
                name: "Other"
                options: [
                    SwitchOption {
                        title: "what"
                    },
                    SliderOption {},
                    SpinOption {},
                    SwitchOption {}
                ]
            }
        }
    }
}
