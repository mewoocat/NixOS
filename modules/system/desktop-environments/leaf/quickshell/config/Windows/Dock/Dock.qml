pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
                WlrLayershell.namespace: 'quickshell-dock' 
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                exclusiveZone: 0
                color: "transparent"
                anchors {
                    bottom: true
                }
                //implicitHeight: indicator.height
                //implicitWidth: indicator.width
                // WARNING: dynamically chaging the size of PanelWindow blurred with a BackgroundEffect, seems
                // to cause the blur area to lag.  Instead, set the size of the PanelWindow to the max needed.
                implicitHeight: Root.State.dockHeight
                implicitWidth: Math.min(appRow.width, window.screen.width)
                property bool active: false

                // Specify the region of the layer to have blur applied to it
                BackgroundEffect.blurRegion: Region {
                    item: appBox // use the appBox since it's the element which moves
                    topLeftRadius: Root.State.rounding
                    topRightRadius: Root.State.rounding
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
                    color: "transparent"

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
                            color: "transparent"
                            id: appBox
                            y: height // Hide by default
                            width: parent.width
                            height: background.height
                            ClippingRectangle {
                                id: background
                                anchors.centerIn: parent
                                width: Math.min(appRow.width, window.screen.width)
                                height: appRow.height
                                color: Root.State.colors.surface
                                topLeftRadius: Root.State.rounding
                                topRightRadius: Root.State.rounding
                                RowLayout {
                                    id: appRow
                                    anchors.centerIn: parent
                                    Repeater {
                                        model: ToplevelManager.toplevels
                                        Ctrls.Button {
                                            id: dockButton
                                            required property Toplevel modelData
                                            implicitWidth: 64
                                            implicitHeight: 64
                                            inset: 8
                                            padding: 0
                                            radius: Root.State.rounding
                                            icon.name: modelData.appId
                                            icon.width: 40
                                            icon.height: 40
                                            isMultiColorIcon: true
                                            onClicked: () => modelData.activate()
                                            indicator: Rectangle {
                                                id: openedWindowsIndicator
                                                anchors.bottom: dockButton.bottom
                                                anchors.horizontalCenter: dockButton.horizontalCenter
                                                color: "transparent"
                                                width: dockButton.inset
                                                height: dockButton.inset
                                                Rectangle {
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    anchors.top: parent.top
                                                    anchors.margins: 2
                                                    height: 4
                                                    width: 4
                                                    radius: height
                                                }
                                            }
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
                                /*
                                window {
                                    implicitHeight: Root.State.dockHeight
                                    implicitWidth: Math.min(appRow.width, window.screen.width)
                                }
                                */
                                mouseArea {
                                    width: dock.width
                                }
                                indicator {
                                    visible: false
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
                                PropertyAction { target: mouseArea; property: "width"; }
                                //PropertyAction { targets: window; properties: "implicitHeight,implicitWidth"; }
                                PropertyAction { target: indicator; property: "visible" }
                                PropertyAnimation { target: appBox; property: "y"; duration: root.animationSpeed; easing.type: root.easingType }
                            }
                        }
                    ]
                }
            }
        }
    }
}
