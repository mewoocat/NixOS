pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs as Root

Scope {
    // This creates an instance for each screen
    Variants {
        model: Quickshell.screens 
        delegate: Component {
            PanelWindow { // qmllint disable uncreatable-type
                id: dock
                property var modelData
                property int animationSpeed: 200
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                // The screen from the screens list will be injected into this property
                color: "transparent"
                screen: modelData
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
                implicitHeight: dock.active ? Root.State.dockHeight : indicator.height
                property bool active: false

                // Specify the region of the layer to have blur applied to it
                BackgroundEffect.blurRegion: Region {
                    item: background
                    radius: background.radius
                }

                Timer {
                    id: closeTimer
                    interval: 250
                    onTriggered: dock.active = false
                }

                Item {
                    id: indicator
                    visible: !dock.active
                    width: 200
                    height: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle {
                        color: Root.State.colors.on_surface
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: height
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.centerIn: parent
                    hoverEnabled: true
                    onEntered: {
                        dock.active = true
                        closeTimer.running = false
                    }
                    onExited: closeTimer.running = true
                    height: Root.State.dockHeight
                    width: dock.active ? parent.width : 200
                    Behavior on width { PropertyAnimation { duration: dock.animationSpeed } }

                    Item {
                        y: dock.active ? 0 : height
                        Behavior on y { PropertyAnimation { duration: dock.animationSpeed } }
                        width: parent.width
                        height: parent.height
                        ClippingRectangle {
                            id: background
                            anchors.centerIn: parent
                            width: Math.min(appRow.width, dock.screen.width)
                            Behavior on width { PropertyAnimation { duration: dock.animationSpeed } }
                            height: appRow.height
                            color: Root.State.colors.surface
                            radius: Root.State.rounding
                            RowLayout {
                                id: appRow
                                anchors.centerIn: parent
                                Repeater {
                                    model: ToplevelManager.toplevels
                                    Shared.PanelButton {
                                        required property Toplevel modelData
                                        text: modelData.appId
                                        icon.name: modelData.appId
                                        icon.width: 36
                                        icon.height: 36
                                        isMultiColorIcon: true
                                        onClicked: () => modelData.activate()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
