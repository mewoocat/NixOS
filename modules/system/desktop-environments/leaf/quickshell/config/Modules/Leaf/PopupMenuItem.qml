import QtQuick
import QtQuick.Layouts
import qs.Modules.Leaf as Leaf
import qs.Components.Controls as Ctrls

// For generic popup menus
// TODO: Should probably implement the MenuItem control for this: https://doc.qt.io/qt-6/qml-qtquick-controls-menuitem.html
Ctrls.Button { 
    id: root
    //implicitWidth: parent.width
    Layout.fillWidth: true
    radius: 4
    leftInset: 6
    rightInset: 6
}
