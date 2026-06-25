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
        id: widgetPager
        spacing: 0
        property bool editable: false
        /* For flick impl
        property int pageCount: 5
        property int currentPage: 0
        property int pageX: flickable.width * currentPage
        */

        property AbsGrid.PanelTile selectedTile: null
        onSelectedTileChanged: console.log(`widgetPager.selectedTile changed to ${selectedTile}`)

        // Page impl
        RowLayout {

            // Seems that when dragging the MouseArea doesn't emit entered signal until the mouse is released
            DropArea {
                width: panelGridPage1.width
                height: panelGridPage1.height
                onEntered: () => { 
                    console.log(`entered 1`)
                    if (widgetPager.selectedTile) {
                        widgetPager.selectedTile.parent = panelGridPage1
                        panelGridPage2.selectedTile = null
                        panelGridPage1.selectedTile = widgetPager.selectedTile
                    }
                }
                AbsGrid.PanelGrid {
                    id: panelGridPage1
                    xSize: 12
                    ySize: 10
                    model: Root.State.config.widgetPager[0]
                    editable: widgetPager.editable
                    onModelUpdated: (newInstances) => {
                        Root.State.config.widgetPager[0] = newInstances
                        Root.State.configFileView.writeAdapter()
                    }
                    onSelectedTileChanged: () => {
                        if (selectedTile) { widgetPager.selectedTile = selectedTile }
                    }
                }
            }

            DropArea {
                width: panelGridPage2.width
                height: panelGridPage2.height
                onEntered: () => {
                    console.log(`entered 2`)
                    if (widgetPager.selectedTile) {
                        widgetPager.selectedTile.parent = panelGridPage2
                        panelGridPage1.selectedTile = null
                        panelGridPage2.selectedTile = widgetPager.selectedTile
                    }
                }
                AbsGrid.PanelGrid {
                    id: panelGridPage2
                    xSize: 12
                    ySize: 10
                    model: Root.State.config.widgetPager[1]
                    editable: widgetPager.editable
                    onModelUpdated: (newInstances) => {
                        Root.State.config.widgetPager[1] = newInstances
                        Root.State.configFileView.writeAdapter()
                    }
                    onSelectedTileChanged: () => {
                        if (selectedTile) { widgetPager.selectedTile = selectedTile }
                    }
                }
            }
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
                        //count: widgetPager.pageCount
                        //currentIndex: widgetPager.currentPage
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
                        onClicked: widgetPager.editable = !widgetPager.editable
                    }
                }
            }
        }

        // Scrolling impl
        /*
        Flickable {
            id: flickable
            height: panelGrid.height
            width: panelGrid.width / widgetContent.pageCount
            contentHeight: panelGrid.height
            contentWidth: panelGrid.width
            contentX: widgetContent.pageX
            Behavior on contentX { PropertyAnimation { duration: 250 } }
            onDraggingChanged: {
                if (!dragging) {
                    console.log(`not moving`)
                    // Get the closest page
                    widgetContent.currentPage = Math.min(
                        Math.max(
                            0,
                            Math.round(contentX / width)
                        ), 
                        widgetContent.pageCount - 1
                    )
                    contentX = widgetContent.pageX
                }
            }
            AbsGrid.PanelGrid {
                id: panelGrid
                xSize: 12 * widgetContent.pageCount
                ySize: 10
                model: Root.State.config.activityCenterWidgets
                editable: widgetContent.editable
                onModelUpdated: (newInstances) => {
                    Root.State.config.activityCenterWidgets = newInstances
                    Root.State.configFileView.writeAdapter()
                }
            }
        }
        */
    }
}

