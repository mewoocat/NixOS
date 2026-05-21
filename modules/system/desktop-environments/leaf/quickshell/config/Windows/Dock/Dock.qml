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
                screen: modelData
                property int animationSpeed: 2000
                property var easingType: Easing.InOutQuint
                property int indicatorWidth: 200
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
                    onTriggered: dock.active = false
                }

                Rectangle {
                    id: box
                    anchors.fill: parent

                    Item {
                        id: indicator
                        visible: !dock.active
                        width: dock.indicatorWidth
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
                        width: indicator.width
                        //Behavior on width { PropertyAnimation { duration: dock.animationSpeed; easing.type: dock.easingType } }

                        Item {
                            id: appBox
                            y: height // Hide by default
                            //Behavior on y { PropertyAnimation { duration: dock.animationSpeed; easing.type: dock.easingType } }
                            width: parent.width
                            height: parent.height
                            ClippingRectangle {
                                id: background
                                anchors.centerIn: parent
                                width: Math.min(appRow.width, dock.screen.width)
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
                            when: dock.active
                            PropertyChanges {
                                dock {
                                    implicitHeight: Root.State.dockHeight
                                }
                                mouseArea {
                                    width: box.width
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
                                PropertyAnimation { target: dock; duration: 0 }
                                PropertyAnimation { target: mouseArea; duration: 0 }
                                PropertyAnimation { target: appBox; duration: dock.animationSpeed; easing.type: dock.easingType }
                            }
                        }
                    ]
                }
            }
        }
    }
}
