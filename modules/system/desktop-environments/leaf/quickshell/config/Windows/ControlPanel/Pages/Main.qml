import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls
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
        }
    ]
}
