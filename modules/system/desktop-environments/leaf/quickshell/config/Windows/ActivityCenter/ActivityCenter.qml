pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

Shared.PanelWindow {
    name: "activityCenter"
    visible: Root.State.activityCenterActive
    padding: 8

    anchors {
        top: true
    }

    onCloseRequested: () => {
        Root.State.activityCenterActive = false
    }

    content: ColumnLayout {
        id: widgetContent
        spacing: 0
        property bool editable: false
        property int pageCount: 5

        // Note: anchors and width/height do not apply to direct children of a SwipeView, use implicit sizes instead
        SwipeView {
            id: swipeView
            implicitWidth: 1000//panelGrid.width / widgetContent.pageCount
            AbsGrid.PanelGrid {
                id: panelGrid
                xSize: 60// * widgetContent.pageCount
                ySize: 10
                model: Root.State.config.activityCenterWidgets
                editable: widgetContent.editable
                onModelUpdated: (newInstances) => {
                    Root.State.config.activityCenterWidgets = newInstances
                    Root.State.configFileView.writeAdapter()
                }
            }
            Rectangle {
                color: "#7700ff00"
                implicitWidth: panelGrid.implicitWidth / widgetContent.pageCount
                implicitHeight: panelGrid.implicitHeight
            }
            /*
            Rectangle {
                color: "#77ff0000"
                implicitWidth: panelGrid.implicitWidth / widgetContent.pageCount
                implicitHeight: panelGrid.implicitHeight
            }
            Rectangle {
                color: "#770000ff"
                implicitWidth: panelGrid.implicitWidth / widgetContent.pageCount
                implicitHeight: panelGrid.implicitHeight
            }
            */
        }
        Rectangle {
            implicitHeight: box.height + box.padding * 2
            Layout.fillWidth: true
            color: "#00000000"

            Rectangle {
                id: box
                property int padding: Root.State.widgetPadding
                x: padding
                y: padding
                width: parent.width - padding * 2
                height: row.height
                radius: Root.State.widgetRounding
                color: Root.State.colors.surface_container
                RowLayout {
                    id: row
                    width: parent.width
                    spacing: 0

                    Shared.TextBlock {
                        text: "Widget System"
                    }
                    PageIndicator {
                        id: pageIndicator
                        count: swipeView.count
                        currentIndex: swipeView.currentIndex
                        // A pressed and index property is available for each delegate
                        delegate: Rectangle {
                            required property int index
                            color: Root.State.colors.on_surface
                            opacity: index === pageIndicator.currentIndex ? 1 : 0.3
                            Behavior on opacity { OpacityAnimator { duration: 150 } }
                            width: 12
                            height: 12
                            radius: height
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 20
                    }
                    Ctrls.Button {
                        id: editButton
                        text: "edit"
                        onClicked: widgetContent.editable = !widgetContent.editable
                    }
                }
            }

        }
    }
}

