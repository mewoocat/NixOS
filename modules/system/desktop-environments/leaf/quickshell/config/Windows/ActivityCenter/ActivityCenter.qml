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

        onVisibleChanged: if (!visible) editable = false

        property AbsGrid.PanelTile selectedTile: null
        onSelectedTileChanged: console.log(`widgetPager.selectedTile changed to ${selectedTile}`)
        property AbsGrid.PanelGrid srcGrid: null
        onSrcGridChanged: print(`srcGrid: ${srcGrid}`)

        property int srcIndex: -1
        property int dstIndex: -1

        // Page impl
        //
        // BIG WARNING: Keep in mind that when a tile is dragged onto a different grid, the item isn't recreated, meaning
        // that it's signal handlers are still configured relative to it's original grid that instantiated it.
        //
        // TODO:
        // - Persist the state changes in memory by altering the source models
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
                        if (!widgetPager.selectedTile) { return }

                        // Turns ghost off for previous PanelGrid
                        widgetPager.selectedTile.panelGrid.selectedTile = null

                        // Update parent and panelGrid for the PanelTile
                        widgetPager.selectedTile.parent = panelGridPage
                        widgetPager.selectedTile.panelGrid = panelGridPage

                        // Update destination index
                        widgetPager.dstIndex = page.pageIndex

                        // Turn on ghost for current PanelGrid
                        panelGridPage.selectedTile = widgetPager.selectedTile

                        // If the tile was dragged onto a grid different than the source
                        if (widgetPager.srcGrid !== panelGridPage) {
                            console.log(`preparing for drop on different grid`)
                        }
                        // Otherwise the tile was dragged onto it's source grid 
                        // (occurs even without dragging outside the source grid)
                        else {
                            print(`preparing for drop on same grid`)
                        }
                    }
                    AbsGrid.PanelGrid {
                        id: panelGridPage
                        xSize: 12
                        ySize: 10
                        property int pageIndex: page.pageIndex
                        model: Root.State.config.widgetPager[page.pageIndex]
                        editable: widgetPager.editable
                        /*
                        onModelUpdated: (newInstances) => {
                            Root.State.config.widgetPager[0] = newInstances
                            Root.State.configFileView.writeAdapter()
                        }
                        */
                        onSelectedTileChanged: print(`${panelGridPage}: selected tile changed to ${selectedTile}`)
                        onTileDragStarted: (tile) => {
                            print(`Pager:onDragStarted: ${tile}`)
                            // Track the tile as the current selected tile across all pages
                            widgetPager.selectedTile = tile
                            // Set the source grid and index

                            // TODO: I think this will be wrong if the model isn't updated and the tile changes
                            // grids since it's still hooked up to it's original grid.
                            //widgetPager.srcGrid = panelGridPage
                            // this might be fix below
                            widgetPager.srcGrid = tile.panelGrid

                            widgetPager.srcIndex = page.pageIndex
                        }
                        onTileDropAccepted: (panelTile) => {

                            print(`pager:onTileDropAccepted: panelGridPage: ${panelGridPage}`)
                            print(`pager:onTileDropAccepted: widgetPager.srcGrid: ${widgetPager.srcGrid}`)

                            // If the tile got dropped on a different grid
                            // If this grid (that the drop occurred on) is not the source grid
                            if (widgetPager.srcGrid !== widgetPager.selectedTile.panelGrid) {
                                print(`tile drop on different grid: srcGrid: ${widgetPager.srcGrid} targetGrid: ${widgetPager.selectedTile.panelGrid}`)

                                // Remove the tile from it's source grid
                                /*
                                const removeIndex = Root.State.config.widgetPager[widgetPager.srcGrid.pageIndex]
                                                        .findIndex((e) => e.uid === panelTile.widgetData.uid)
                                Root.State.config.widgetPager[widgetPager.srcGrid.pageIndex].splice(removeIndex, 1)
                                // Add tile to it's destination grid
                                const addObject = {
                                    uid: panelTile.widgetData.uid,
                                    xPosition: panelTile.widgetData.xPosition,
                                    yPosition: panelTile.widgetData.yPosition,
                                    state: panelTile.widgetData.state
                                }
                                Root.State.config.widgetPager[widgetPager.dstGrid.pageIndex].push(addObject)

                                const temp = Root.State.config.widgetPager
                                Root.State.config.widgetPager = []
                                Root.State.config.widgetPager = temp

                                print(`writing pager data`)
                                Root.State.configFileView.writeAdapter()
                                */

                                /*
                                // Regenerate the instances for the source grid (this grid)
                                Root.State.config.widgetPager[0] = generateInstances()
                                // Regenerate the instances for the destination grid (the grid the selected tile was dropped on)
                                Root.State.config.widgetPager[widgetPager.selectedTileDstGridIndex] = generateInstances()
                                */
                            }
                            // If the tile got dropped on the same grid it originated from
                            else {
                                print(`tile drop on same grid`)
                                // Only need to update this grid
                                /*
                                Root.State.config.widgetPager[0] = generateInstances()
                                Root.State.configFileView.writeAdapter()
                                */
                            }

                            // Turn off ghost for current hovered grid
                            widgetPager.selectedTile.panelGrid.selectedTile = null

                            // Reset state
                            widgetPager.selectedTile = null
                            widgetPager.srcGrid = null
                            widgetPager.srcIndex = -1
                            widgetPager.dstIndex = -1
                        }
                        
                        // TODO: test
                        onTileDropRejected: () => {
                            // If the tile got rejected on a different grid
                            if (widgetPager.selectedTile.panelGrid !== panelGridPage) {
                                // Reparent it back to the original parent
                                widgetPager.selectedTile.parent = widgetPager.srcGrid
                                // Set the tile's panelGrid back to the source
                                widgetPager.selectedTile.panelGrid = widgetPager.srcGrid
                                // No need to track the selectedTile anymore
                                widgetPager.selectedTile = null
                            }
                        }
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
    }
}

