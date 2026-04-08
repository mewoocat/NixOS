pragma ComponentBehavior: Bound

import QtQuick
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

AbsGrid.WidgetData { 
    id: widgetData
    name: "..."
    xSize: 1
    ySize: 1
    showBackground: false
    onPanelGridChanged: console.debug(`ExpandTest's PanelGrid: ${panelGrid}`)
    component: Shared.Expander {
        id: root
        backdrop: widgetData.panelGrid
        Component.onCompleted: console.debug(`widget's backdrop: ${backdrop}`)
        onParentChanged: console.debug(`PARENT: ${parent}`)
        button: Ctrls.Button { 
            inset: 0
            onClicked: () => root.showContent()
            backgroundColor: hovered ? Root.State.colors.primary : Root.State.colors.surface_container
            icon.name: "weather-clear-night-symbolic"
            radius: widgetData.radius
        }
        content: Rectangle {
            //anchors.fill: parent
            width: 100
            height: 100
            color: "red"
            Ctrls.Button {
                onClicked: () => root.hideContent()
                text: "hide"
            }
        }
    }
}
