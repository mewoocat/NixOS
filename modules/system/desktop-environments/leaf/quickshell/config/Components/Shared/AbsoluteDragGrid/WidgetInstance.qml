import QtQuick
import QtQml
import Quickshell
import Quickshell.Io

// Can't seem to dynamically create a JsonObject
//
QtObject {
    required property string uid
    required property int xPosition
    required property int yPosition
    property var state: null
} 
