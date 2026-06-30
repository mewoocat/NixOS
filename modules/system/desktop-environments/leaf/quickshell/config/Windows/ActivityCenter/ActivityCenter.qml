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

        property AbsGrid.PanelTile selectedTile: null
        property int selectedTileDstGridIndex: 0
        property AbsGrid.PanelGrid srcGrid: null
        property AbsGrid.PanelGrid dstGrid: null
        onSelectedTileChanged: console.log(`widgetPager.selectedTile changed to ${selectedTile}`)

        // !! TODO: Look into adding/removing the dragged widgetdata to/from the dst/src panel grid models
        // That way, we shouldn't have to manually do any reparenting and the panel grid can always handle the position checking.

        // Page impl
        RowLayout {

            Repeater {
                model: 2
                delegate: DropArea {
                    id: page
                    required property int modelData
                    property int pageIndex: modelData
                    width: panelGridPage.width
                    height: panelGridPage.height
                    onEntered: () => { 
                        console.log(`widget pager drop grid entered (${pageIndex})`)
                        if (widgetPager.selectedTile && widgetPager.selectedTile.parent !== widgetPager.srcGrid) {
                            console.log(`calculating drop`)
                            widgetPager.selectedTile.parent = panelGridPage
                            widgetPager.selectedTile.panelGrid = panelGridPage
                            widgetPager.dstGrid = panelGridPage

                            // Swap the selected tiles
                            widgetPager.srcGrid.selectedTile = null
                            widgetPager.dstGrid.selectedTile = widgetPager.selectedTile

                            widgetPager.selectedTileDstGridIndex = pageIndex
                        }
                    }
                    AbsGrid.PanelGrid {
                        id: panelGridPage
                        xSize: 12
                        ySize: 10
                        model: Root.State.config.widgetPager[page.pageIndex]
                        editable: widgetPager.editable
                        /*
                        onModelUpdated: (newInstances) => {
                            Root.State.config.widgetPager[0] = newInstances
                            Root.State.configFileView.writeAdapter()
                        }
                        */
                        onSelectedTileChanged: () => {
                            // If a tile on this grid was selected
                            if (selectedTile) {
                                // Track the tile as the current selected tile across all pages
                                widgetPager.selectedTile = selectedTile
                                // Set the source grid to this grid
                                widgetPager.srcGrid = panelGridPage
                            }
                            /*
                            else {
                                widgetPager.selectedTile = null
                            }
                            */
                        }
                        onTileDropAccepted: () => {

                            // If the tile got dropped on a different grid
                            if (widgetPager.dstGrid !== panelGridPage) {
                                // Remove the tile from it's source grid
                                //widgetPager.srcGrid.removeTile(selectedTile.widgetData)
                                // Add tile to it's destination grid
                                //widgetPager.dstGrid.addTile(selectedTile.widgetData)

                                /*
                                // Regenerate the instances for the source grid (this grid)
                                Root.State.config.widgetPager[0] = generateInstances()
                                // Regenerate the instances for the destination grid (the grid the selected tile was dropped on)
                                Root.State.config.widgetPager[widgetPager.selectedTileDstGridIndex] = generateInstances()
                                Root.State.configFileView.writeAdapter()
                                */
                            }
                            // If the tile got dropped on the same grid it originated from
                            else {
                                // Only need to update this grid
                                /*
                                Root.State.config.widgetPager[0] = generateInstances()
                                Root.State.configFileView.writeAdapter()
                                */
                            }
                            widgetPager.selectedTile = null
                        }
                        onTileDropRejected: () => {
                            // If the tile got rejected on a different grid
                            if (widgetPager.dstGrid !== panelGridPage) {
                                // Reparent it back to the original parent
                                widgetPager.selectedTile.parent = widgetPager.srcGrid
                                // No need to track the selectedTile anymore
                                widgetPager.selectedTile = null
                            }
                        }
                    }
                }
            }

            /*
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

