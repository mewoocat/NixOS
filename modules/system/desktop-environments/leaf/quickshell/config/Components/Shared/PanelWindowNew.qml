pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

import qs as Root
import qs.Services as Services

// TODO: I think that the required keyword doesn't trigger an error on missing 
// prop with the PanelWindow type (need to test)
PanelWindow {
    id: root
    required property string name // Needs to be camelCase
    required property Item content // Thing to place in window
    required property Item anchorItem // The item to anchor the window to

    onVisibleChanged: {
        // Get the origin of the anchorItem relative to the screen (Right now just the bottom right point)
        const point = QsWindow.mapFromItem(anchorItem, anchorItem.width, anchorItem.height)
        anchorPoint = point
    }
    property point anchorPoint: Qt.point(0, 0)
    property int padding: Root.State.windowPadding
    property int margin: Root.State.windowMargin
    property int radius: Root.State.rounding

    visible: false
    
    // Defaults to int assignments 0,1,2,...etc.
    enum Gravity {
        Left,
        Right,
        Top,
        Bottom
    }

    signal closeWindow()
    signal toggleWindow()
 
    /*
    Component.onCompleted: {
        //console.log(`setting state for window: ${name}`)
        Root.State[name] = window // Set the window ref in state
    }
    */

    exclusionMode: ExclusionMode.Ignore
    exclusiveZone: 0 // Prevents windows with one anchor fron taking up tiling space
    //focusable: true 
    color: "transparent"

    property int xGravity: PanelWindowNew.Gravity.Left
    property int yGravity: PanelWindowNew.Gravity.Bottom

    anchors.top: true
    anchors.left: true
    // WARNING HACK! Using margins from top left to set window position relative to screen coords.
    margins {
        left: {
            console.debug(`------------------- yGravity ${xGravity}`)
            console.debug(`------------------- anchorPoint ${root.anchorPoint}`)
            switch (xGravity) {
                case PanelWindowNew.Gravity.Left:
                    return root.anchorPoint.x - root.implicitWidth
                case PanelWindowNew.Gravity.Right:
                    return root.anchorPoint.x
                default:
                    console.error(`invalid x gravity`)
                    return 0
            }
        }
        top: {
            console.debug(`------------------- yGravity ${yGravity}`)
            switch (yGravity) {
                case PanelWindowNew.Gravity.Top:
                    return root.anchorPoint.y - root.implicitHeight
                case PanelWindowNew.Gravity.Bottom:
                    return root.anchorPoint.y
                default:
                    console.error(`invalid y gravity`)
                    return 0
            }
        }
    }

    WlrLayershell.namespace: 'quickshell-panel-' + name // Set layer name
    //WlrLayershell.namespace: 'quickshell' // Set layer name
    // Specify the region of the layer to have blur applied to it
    BackgroundEffect.blurRegion: Region {
        item: background
        radius: background.radius
    }

    // Visibility

    // TODO: make each panel window have their own focus grab
    /*
    onVisibleChanged: {
        if (window.grabEnabled) {
            if (visible) {
                Root.State.clickAwayVisible = true
                Root.State.focusStack.push(window)
            }
            else {
                Root.State.focusStack.pop()
            }
        }
    }
    */

    implicitWidth: background.width
    implicitHeight: background.height // NOTE: Need to set PanelWindow size to largest possible or else resizing with jitter

    //////////////////////////////////////////////////////////////// 
    // FocusScope is used to ensure the last item with focus set to true
    // receives the actual focus.  This is useful for a text field in
    // a window, as we would want that to have focus but then any non handled
    // key events would automatically propogate up back to the window and
    // handled here.
    // See: https://doc.qt.io/qt-6/qtquick-input-focus.html
    FocusScope {
        id: focusScope
        width: background.width
        height: background.height
        focus: true
        Keys.onPressed: (event) => {
            if (event.key == Qt.Key_Escape) {
                root.closeWindow()
            }
        }
        Rectangle {
            id: background
            color: Root.State.colors.surface
            radius: root.radius
            implicitWidth: root.content.width + root.padding * 2
            implicitHeight: root.content.height + root.padding * 2
            Rectangle {
                x: root.padding
                y: root.padding
                color: "transparent"
                implicitWidth: root.content.width
                implicitHeight: root.content.height
                children: [
                    root.content
                ]
            }
        }
    }

    //////////////////////////////////////////////////////////////// 
    // Close on Click Away
    // Creates a fullscreen panel window for each screen.  Any clicks made on 
    // it will close the root panel window of this component.
    Variants {
        model: Quickshell.screens 
        // qmllint disable uncreatable-type
        PanelWindow {
            id: window
            visible: root.visible
            required property ShellScreen modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            color: "#33ff0000"
            MouseArea {
                id: area
                hoverEnabled: true
                anchors.fill: parent
                onClicked: () => {
                    console.log(`what`)
                    root.visible =false
                }
            }
            // Allow clicks to pass through
            // Doesn't seem to be a way to do this *and* detect mouse clicks
            /*
            mask: Region {
                item: area
                intersection: Intersection.Subtract
            }
            */
        }
    }
}

