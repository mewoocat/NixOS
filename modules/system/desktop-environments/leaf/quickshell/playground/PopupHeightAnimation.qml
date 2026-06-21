import QtQuick
import QtQuick.Controls.Basic
import Quickshell

FloatingWindow {
  color: "black"

  Button {
    text: "Open"
    onClicked: popup.visible = !popup.visible
  }

  ComboBox {
      id: comobobox
      model: ["adadafsd", "sopidfjpsdoif", "apdsoifjasd"]

  popup: Menu {
    id: popup

    width : 600
    popupType: C.Popup.Window

    //x: 100
    y: comobobox.height

    background: Rectangle {
      color: "white"
      radius: 12
      border.color: "grey"
    }

    enter: Transition {
      NumberAnimation {
        property: "height"
        from: 0
        to: 600
        duration: 2000
      }
    }

    exit: Transition {
      NumberAnimation {
        property: "height"
        from: 600
        to: 0
        duration: 2000
      }
    }

    ListView {
      id: listView
      model: DesktopEntries.applications
      anchors.fill: parent

      delegate: Text {
        required property DesktopEntry modelData
        
        text: modelData?.name ?? ""
      }
    }
  }
  }
}
