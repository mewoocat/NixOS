
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

FloatingWindow {
    id: root
    SwipeView {
        id: swipeView
        implicitWidth: 200//panelGrid.width / widgetContent.pageCount
        implicitHeight: 200
        /*
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
        */
        Rectangle {
            color: "green"
            implicitHeight: 150
            implicitWidth: 150
        }
        Repeater {
            model: 5
            Rectangle {
                color: "red"
                implicitHeight: 100
                implicitWidth: 100
                /*
                implicitWidth: panelGrid.implicitWidth / widgetContent.pageCount
                implicitHeight: panelGrid.implicitHeight
                */
            }
        }
    }
}
