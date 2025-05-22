import "root:/Modules/Ui" as Ui
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "root:/" as Root
import "./Pages" as Pages

Ui.PopupWindow {
    name: "controlPanel"
    visible: Root.State.controlPanelVisibility
    width: 300
    height: content.height
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
        //width: parent.width
        width: 300
        // can't use contentHeight since it uses the implicit size of the children
        // and due to a bug, we need to use non implicit size for the grid child
        height: currentItem.height // / 2
        //implicitHeight: 400
        currentIndex: Root.State.controlPanelPage
        // Multiple items here seems to make the width of the swipeview expand when accessed?
        Pages.Main {} 
        Pages.Audio {}
        //Pages.Audio {}
    }

    /*
    content: ColumnLayout { 
        implicitWidth: parent.width
        implicitHeight: childrenRect.height
        SwipeView {
            id: swipeView
            implicitWidth: parent.width
            // can't use contentHeight since it uses the implicit size of the children
            // and due to a bug, we need to use non implicit size for the grid child
            implicitHeight: contentChildren[currentIndex].height
            currentIndex: Root.State.controlPanelPage
            Pages.Main {} 
            Pages.Audio {}
            Pages.Audio {}
        }

        PageIndicator {
            id: pageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            //anchors.bottom: swipeView.bottom
            //anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
        }
    }
    */
}
