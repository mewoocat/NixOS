import QtQuick
import QtQuick.Layouts
import qs.Modules.Leaf as Leaf

// For generic popup menus
// TODO: Should probably implement the MenuItem control for this: https://doc.qt.io/qt-6/qml-qtquick-controls-menuitem.html
Leaf.Button { 
    id: root
    //implicitWidth: parent.width
    Layout.fillWidth: true
    radius: 4
    leftInset: 6
    rightInset: 6
}
