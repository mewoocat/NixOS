import QtQuick
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import "../Widgets" as Widgets

AbsGrid.PanelGrid {
    id: panelGrid
    xSize: 4
    ySize: 6
    onModelUpdated: (newModel) => model = newModel
    model: [
        Widgets.Network {
            xPosition: 0
            yPosition: 0
        },
        Widgets.ScreenCapture {
            xPosition: 2
            yPosition: 0
        },
        Widgets.NightLight {
            xPosition: 3
            yPosition: 0
        },
        Widgets.AudioAndBrightness {
            xPosition: 0
            yPosition: 4
        }
    ]
}
