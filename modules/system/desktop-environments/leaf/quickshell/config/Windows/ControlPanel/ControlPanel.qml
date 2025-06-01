import QtQuick
import QtQuick.Controls
import "../../" as Root
import "../../Modules/Common" as Common
import "./Pages" as Pages

Common.PopupWindow {
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility
    implicitWidth: content.width
    implicitHeight: content.height
    toggleWindow: () => {
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 
    closeWindow: () => {
        Root.State.controlPanelVisibility = false
    } 
    anchors {
        top: true
        right: true
    }

    //content: Pages.Main {} 
    content: SwipeView {
        id: swipeView
        //width: 300
        // can't use contentHeight since it uses the implicit size of the children
        // and due to a bug, we need to use non implicit size for the grid child
        implicitHeight: contentHeight
        implicitWidth: contentWidth
        currentIndex: Root.State.controlPanelPage

        // Multiple items here seems to make the width of the swipeview expand when accessed?
        Pages.Main {} 
        Pages.Audio {}

        /*
        PageIndicator {
            id: pageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            //anchors.bottom: swipeView.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
        }
        */
    }
}
