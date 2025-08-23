import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs as Root
import qs.Services as Services
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
                        title: "Workspace"
                        subtitle: "The workspace to modify"
                        // TODO: Use this https://doc.qt.io/qt-6/qml-qtquick-controls-combobox.html#model-prop
                        content: ComboBox {
                            textRole: "wsId" // The property name on each of the model items to show as the text
                            model: {
                                const wsConfig = Root.State.config.workspaces.wsMap
                                // Convert the obj map of workspace config objs to array
                                let workspaces = []
                                for (let id = 1; id <= 10; id++) {
                                    const wsId = `ws${id}`
                                    console.log(`option: ${wsConfig[wsId]}`)
                                    workspaces.push(wsConfig[`ws${id}`])
                                }
                                return workspaces //.map(ws => ws.wsId)
                            }
                            onActivated: (index) => {
                                console.log(`activated combobox for index ${index}`)
                                Services.Hyprland.selectedWorkspaceId = index + 1
                                console.log(`selected workspace: ${Services.Hyprland.selectedWorkspace.wsId}`)
                            }
                        }
                    },
                    Option {
                        title: "Name"
                        subtitle: "The name to assign to this workspace"
                        content: TextField {
                            onAccepted: {
                                Services.Hyprland.setWsName(text)
                                Services.Hyprland.applyWsConf()
                            }
                        }
                    },
                    Option {
                        title: "Monitor"
                        subtitle: "The monitor to assign this workspace to"
                        content: ComboBox {
                            model: [
                                "Monitor 1",
                                "Monitor 2",
                                "Monitor 3"
                            ]
                        }
                    },
                    Option {
                        title: "Rounding"
                        content: Switch {
                            onClicked: {
                                Services.Hyprland.selectedWorkspace.rounding = checked
                                console.log(`rounding: ${Services.Hyprland.selectedWorkspace.rounding}`)
                                Services.Hyprland.applyWsConf()
                            }
                        }
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
