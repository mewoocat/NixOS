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
        property int srcGridIndex: -1
        property int dstGridIndex: -1
        property AbsGrid.PanelGrid srcGrid: null
        onSrcGridChanged: print(`srcGrid: ${srcGrid}`)
        property AbsGrid.PanelGrid dstGrid: null
        onDstGridChanged: print(`dstGrid: ${dstGrid}`)
        onSelectedTileChanged: console.log(`widgetPager.selectedTile changed to ${selectedTile}`)

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
                        if (!widgetPager.selectedTile) { return }

                        // If the tile was dragged onto a grid different than the source
                        if (widgetPager.selectedTile.parent !== panelGridPage) {
                            console.log(`calculating drop`)
                            widgetPager.selectedTile.parent = panelGridPage
                            widgetPager.selectedTile.panelGrid = panelGridPage
                            widgetPager.dstGrid = panelGridPage
                            widgetPager.dstGridIndex = page.pageIndex

                            // Swap the selected tiles
                            widgetPager.srcGrid.selectedTile = null
                            widgetPager.dstGrid.selectedTile = widgetPager.selectedTile

                            widgetPager.dstGridIndex = pageIndex
                        }
                        // Otherwise the tile was dragged onto it's source grid (occurs even without dragging outside the source grid)
                        else {
                            // If a destination grid has been set
                            if (widgetPager.dstGrid) {
                                // No longer need to track selected tile or grid
                                widgetPager.dstGrid.selectedTile = null
                                widgetPager.dstGrid = null
                                widgetPager.dstGridIndex = -1
                            }
                            // Ensure the source grid has the selected tile now
                            widgetPager.srcGrid.selectedTile = widgetPager.selectedTile
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
                            print(`selectedTileChange Received`)
                            // If a tile on this grid was selected
                            if (selectedTile) {
                                // Track the tile as the current selected tile across all pages
                                widgetPager.selectedTile = selectedTile
                                // Set the source grid to this grid
                                widgetPager.srcGrid = panelGridPage
                                widgetPager.srcGridIndex = page.pageIndex
                            }
                        }
                        onTileDropAccepted: (panelTile) => {

                            // TODO: Figure out why drop on different grid evals this conditional to true

                            // If the tile got dropped on a different grid
                            if (widgetPager.dstGrid != null && widgetPager.dstGrid !== panelGridPage) {
                                print(`tile drop on different grid`)
                                widgetPager.srcGrid.selectedTile = null
                                widgetPager.srcGridIndex = -1
                                widgetPager.dstGrid.selectedTile = null
                                widgetPager.dstGridIndex = -1

                                // Remove the tile from it's source grid
                                const removeIndex = Root.State.config.widgetPager[widgetPager.srcGridIndex].findIndex((e) => e.uid === panelTile.widgetData.uid)
                                Root.State.config.widgetPager[widgetPager.srcGridIndex].splice(removeIndex, 1)
                                // Add tile to it's destination grid
                                const addObject = {
                                    uid: panelTile.widgetData.uid,
                                    xPosition: panelTile.widgetData.xPosition,
                                    yPosition: panelTile.widgetData.yPosition,
                                    state: panelTile.widgetData.state
                                }
                                Root.State.config.widgetPager[widgetPager.srcGridIndex].push(addObject)

                                const temp = Root.State.config.widgetPager
                                Root.State.config.widgetPager = []
                                Root.State.config.widgetPager = temp

                                print(`writing pager data`)
                                Root.State.configFileView.writeAdapter()

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
                                widgetPager.srcGrid.selectedTile = null
                                widgetPager.srcGridIndex = -1
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

