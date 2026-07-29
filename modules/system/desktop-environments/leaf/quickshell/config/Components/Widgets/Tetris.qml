import QtQuick
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetData {
    name: "Tetris"
    xSize: 4
    ySize: 4
    padding: 8
    //component: Tetris.Game {}
    component: Loader {
        // Warning: using a url that is a symlink seems to cause any updates to the content in the url not to show up after
        // it's used for the first time.  Likely some weird caching shit going on.

        // For some reason prepending "file://" allows for dependent components to be resolved without a qmldir file
        //source: "file:///home/eXia/Projects/Qetris/Tetris/Game.qml" // Resolves dependent components without qmldir but has issue if symlink

        // This works with symlinks
        source: "/home/eXia/.config/quickshell-widgets/Qetris/Game.qml" // This works as long as a qmldir exists here
    }
}
