import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "root:/" as Root

PanelWindow {
    id: launcher
    visible: Root.State.launcherVisibility
    anchors {
        //top: true
        //left: true
        bottom: true
        right: true
    }
    focusable: true // Enable keyboard focus
    width: 300
    height: 400
    color: "transparent"
    margins {
        left: 16
        top: 16
    }
    Rectangle {
        anchors.fill: parent
        color: "#aa000000"
        radius: 12
        ColumnLayout {
            anchors.fill: parent
            TextField {
                Layout.fillWidth: true
            }
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Repeater {
                        model: DesktopEntries.applications
                        Component.onCompleted: console.log(`model = ${model}`)
                        Rectangle {
                            color: mouseArea.containsMouse ? "#00ff00" : "#222222"
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            height: 40
                            MouseArea {
                                id: mouseArea
                                hoverEnabled: true
                                onClicked: modelData.execute()
                                anchors.fill: parent
                                RowLayout {
                                    anchors.fill: parent
                                    IconImage {
                                        implicitSize: 32
                                        source: Quickshell.iconPath(modelData.icon)
                                    }
                                    Text{
                                        color: "#ff00ff"
                                        text: modelData.name
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
