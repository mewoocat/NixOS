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
                                    workspaces.push(wsConfig[`ws${id}`])
                                }
                                return workspaces //.map(ws => ws.wsId)
                            }
                            onActivated: (index) => {
                                Services.Hyprland.selectedWorkspaceId = index + 1
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
                                console.log(`currentMonitorToWSMap: ${JSON.stringify(Services.Hyprland.currentMonitorToWSMap)}`)
                            }
                        }
                    },
                    Option {
                        title: "Monitor"
                        subtitle: "The monitor to assign this workspace to"
                        content: ComboBox {
                            textRole: "name"
                            valueRole: "name"
                            model: Services.Monitors.monitors // Sorted by id
                            currentIndex: 0 // Index here maps directly to each monitor by id above
                            onActivated: (index) => {
                                const monitorName = Services.Monitors.monitors[index].name
                                Services.Hyprland.assignSelectedWorkspaceToMonitor(monitorName)
                                Services.Hyprland.applyWsConf()
                            }
                        }
                    },
                    Option {
                        title: "Rounding"
                        content: Switch {
                            checked: Services.Hyprland.selectedWorkspace.useGlobalConfig ? Root.State.config.appearance.rounding > 0 : Services.Hyprland.selectedWorkspace.rounding
                            onClicked: {
                                Services.Hyprland.selectedWorkspace.rounding = checked
                                console.log(`rounding: ${Services.Hyprland.selectedWorkspace.rounding}`)
                                Services.Hyprland.applyWsConf()
                            }
                        }
                    },
                    Option {
                        title: "Outer gaps"
                        content: SpinBox {
                            from: 0
                            value: Services.Hyprland.selectedWsGapsOut
                            onValueModified: {
                                Services.Hyprland.selectedWorkspace.gapsOut = value
                                Services.Hyprland.applyWsConf()
                            }
                            to: 100
                        }
                    },
                    Option {
                        title: "Inner gaps"
                        content: SpinBox {
                            from: 0
                            value: Services.Hyprland.selectedWsGapsIn
                            onValueModified: {
                                Services.Hyprland.selectedWorkspace.gapsIn = value
                                Services.Hyprland.applyWsConf()
                            }
                            to: 100
                        }
                    },
                    Option {
                        title: "Test"
                        subtitle: "..."
                        content: TextField {
                            onAccepted: {
                                //Root.State.config.something = text
                                Root.State.config.workspaces.wsMap['ws1'].rounding = false
                                Root.State.config.something = "new data"
                                Root.State.configFileView.writeAdapter()
                            }
                        }
                    }
                ]
            }

            OptionSection {
                name: "Other"
                options: [
                    Option {
                        title: "what"
                        content: Switch {

                        }
                    },
                    Option {
                        title: "test spin box"
                        content: SpinBox {}
                    },
                    Option {
                        title: "test slider"
                        content: Slider {}
                    }
                ]
            }
        }
    }
}
