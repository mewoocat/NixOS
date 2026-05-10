pragma ComponentBehavior: Bound

import QtQuick
import qs.Services as Services
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import qs.Components.Controls as Ctrls

AbsGrid.WidgetData { 
    id: widgetData
    name: "Color Mode"
    xSize: 1
    ySize: 1
    showBackground: false
    component: Ctrls.Button { 
        inset: 0
        onClicked: () => {
            Services.Theme.darkMode = !Services.Theme.darkMode
            //Services.Theme.applyTheme()
        }
        inactiveBackgroundColor: Root.State.colors.surface_container
        checked: Services.Theme.darkMode
        icon.name: "color-mode-black-white-symbolic"
        radius: widgetData.radius
    }
}
