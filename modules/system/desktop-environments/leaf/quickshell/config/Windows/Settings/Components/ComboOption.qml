import QtQuick.Controls

Option {
    required property list<string> options
    content: ComboBox {
        model: options
    }
}
