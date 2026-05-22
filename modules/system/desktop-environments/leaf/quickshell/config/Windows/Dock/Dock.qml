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
    id: root
    property int animationSpeed: 500
    property var easingType: Easing.InOutQuint
    property int indicatorWidth: 200

    // This creates an instance for each screen
    Variants {
        model: Quickshell.screens 
        delegate: Component {
            PanelWindow { // qmllint disable uncreatable-type
                id: window
                property var modelData
                screen: modelData
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                exclusiveZone: 0
                color: "transparent"
                anchors {
                    bottom: true
                    left: true
                    right: true
                }
                implicitHeight: indicator.height
                property bool active: false

                // Specify the region of the layer to have blur applied to it
                BackgroundEffect.blurRegion: Region {
                    item: background
                    radius: background.radius
                }

                Timer {
                    id: closeTimer
                    interval: 250
                    onTriggered: dock.state = ""
                }

                Rectangle {
                    id: dock
                    anchors.fill: parent
                    state: ""
                    color: "green"

                    Item {
                        id: indicator
                        width: root.indicatorWidth
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
                            dock.state = "shown"
                            closeTimer.running = false
                        }
                        onExited: closeTimer.running = true
                        height: Root.State.dockHeight
                        width: indicator.width

                        Rectangle {
                            color: "red"
                            id: appBox
                            y: height // Hide by default
                            width: parent.width
                            height: parent.height
                            ClippingRectangle {
                                id: background
                                anchors.centerIn: parent
                                width: Math.min(appRow.width, window.screen.width)
                                Behavior on width { PropertyAnimation { duration: dock.animationSpeed; easing.type: dock.easingType } }
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
                    states: [
                        State {
                            name: "shown"
                            PropertyChanges {
                                window {
                                    implicitHeight: Root.State.dockHeight
                                }
                                mouseArea {
                                    width: dock.width
                                }
                                appBox {
                                    y: 0
                                }
                            }
                        }
                    ]
                    transitions: [
                        Transition {
                            to: "shown"
                            reversible: true
                            SequentialAnimation { 
                                PropertyAnimation { target: window; property: "implicitHeight"; duration: 0 }
                                PropertyAnimation { target: mouseArea; property: "width"; duration: 0 }
                                PropertyAnimation { target: appBox; property: "y"; duration: root.animationSpeed; easing.type: root.easingType }
                            }
                        }
                    ]
                }
            }
        }
    }
}
