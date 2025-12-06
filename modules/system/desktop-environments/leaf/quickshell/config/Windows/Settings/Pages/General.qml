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
                            background: Rectangle {
                                radius: 8
                                color: palette.alternateBase
                            }
                            text: Services.Hyprland.selectedWorkspace.name
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
                            // ugh. this is really gross
                            currentIndex: {
                                const wsMap = Services.Hyprland.currentMonitorToWSMap
                                for(let key in wsMap) {
                                    if (wsMap[key].includes(Services.Hyprland.selectedWorkspaceId)) {
                                        let monitorIndex = Services.Monitors.monitors.findIndex(m => m.name === key)
                                        console.log("monitorIndex: " + monitorIndex)
                                        return monitorIndex
                                    }
                                }
                            }
                            onActivated: (index) => {
                                const monitorName = Services.Monitors.monitors[index].name
                                Services.Hyprland.assignSelectedWorkspaceToMonitor(monitorName)
                                Services.Hyprland.applyWsConf()
                            }
                        }
                    },
                    Option {
                        title: "Rounding"
                        subtitle: "Whether to round the corners of this workspace"
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
                        subtitle: "Spacing between outside of windows and monitor edge"
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
                        subtitle: "spacing between windows"
                        content: SpinBox {
                            from: 0
                            value: Services.Hyprland.selectedWsGapsIn
                            onValueModified: {
                                Services.Hyprland.selectedWorkspace.gapsIn = value
                                Services.Hyprland.applyWsConf()
                            }
                            to: 100
                        }
                    }
                ]
            }

            OptionSection {
                name: "Mouse"
                options: [
                    Option {
                        title: "Sensitivity"
                        content: Slider {

                        }
                    }
                ]
            }

            OptionSection {
                name: "Fonts"
                options: [
                    Option {
                        title: "System Font"
                        content: ComboBox {

                        }
                    },
                    Option {
                        title: "Font Size"
                        subtitle: "System font size"
                        content: SpinBox {}
                    }
                ]
            }
        }
    }
}
