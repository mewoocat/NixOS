import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.Services as Services
import qs as Root

// TODO: wrap in loader so that popup is only loaded when it needs to be seen
// TODO: Fix issue with moving mouse too slow from button to popupwindow where the popup window 
//       doesn't receive focus right away and thus gets hidden before it can be hovered
// TODO: Add param to set the parent window so that if it has a focus grab we can deactive and active it as needed
PopupWindow {
    id: root

    required property Item content
    implicitWidth: popupArea.width
    implicitHeight: popupArea.height
    color: "transparent"

    function closeWindow() {
        console.log('popup close window')
        root.visible = false
    }

    onVisibleChanged: {
        if (visible) {
            console.log(`popup window vis changed to ${root.visible}`)
            Services.Hyprland.addGrabWindow(root)
        }
    }

    WrapperMouseArea {
        id: popupArea
        enabled: true
        focus: true
        hoverEnabled: true
        WrapperRectangle {
            id: box
            //color: palette.window
            color: "#aa111111"
            radius: Root.State.rounding
            margin: 4
            children: [ root.content ]
        }
    }
}
