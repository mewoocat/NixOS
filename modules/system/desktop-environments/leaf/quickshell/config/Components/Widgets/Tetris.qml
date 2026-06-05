import QtQuick
//import "Tetris" as Tetris
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetData {
    name: "Tetris"
    xSize: 4
    ySize: 4
    //component: Tetris.Game {}
    component: Loader {
        // For some reason prepending "file://" allows for dependent components to be resolved
        source: "file:///home/eXia/.config/quickshell-widgets/Tetris/Game.qml" // Resolves dependent components
        //source: "/home/eXia/.config/quickshell-widgets/Tetris/Game.qml" // Doesn't work
    }
}
