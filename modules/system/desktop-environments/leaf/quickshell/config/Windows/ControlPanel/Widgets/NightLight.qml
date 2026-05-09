pragma ComponentBehavior: Bound

import QtQuick
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

AbsGrid.WidgetData { 
    id: widgetData
    name: "Screen Capture"
    xSize: 1
    ySize: 1
    showBackground: false
    component: Ctrls.Button { 
        inset: 0
        onClicked: () => Services.NightLight.toggle()
        backgroundColor: hovered ? Root.State.colors.surface_container_high : Root.State.colors.surface_container
        icon.name: "weather-clear-night-symbolic"
        radius: widgetData.radius
    }
}
