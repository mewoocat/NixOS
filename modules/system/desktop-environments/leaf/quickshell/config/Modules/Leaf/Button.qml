import QtQuick
import QtQuick.Templates as T

// Custom button based off logic template.  This is the recommended way to create a custom
// style.  Should probably follow this pattern for the rest of the controls
T.Button {
    background: Rectangle {
        color: "teal"
    }
    contentItem: Text {
        text: "click"
    }
}
