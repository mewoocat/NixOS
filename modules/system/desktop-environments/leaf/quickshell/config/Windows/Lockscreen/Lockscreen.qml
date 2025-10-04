pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import qs as Root

Scope {
    PamContext {
        id: context
        configDirectory: "pam"
        config: "password.conf"
        property string currentText: ""
        function unlock (): void {
            if (currentText === "") return
            context.start()
        }
		// pam_unix will ask for a response when started
        onPamMessage: {
            console.log(`msg: ${message}`)
            if (responseRequired) {
                respond(currentText)
            }
        }
        // Emitted whenever authentication completes
        onCompleted: (result) => {
            console.log(`result = ${PamResult.toString(result)}`)
            if (result === PamResult.Success) {
                Root.State.screenLocked = false
            }
        }
    }

    WlSessionLock {
        id: lock
        locked: Root.State.screenLocked
        WlSessionLockSurface {
            Rectangle {
                anchors.fill: parent
                color: palette.window
                ColumnLayout {
                    anchors.centerIn: parent
                    Button {
                        text: "close"
                        onClicked: () => Root.State.screenLocked = false
                    }
                    RowLayout {
                        TextField {
                            focus: true
                            onTextChanged: context.currentText = text
                            onAccepted: context.unlock()
                        }
                        Button {
                            text: "unlock"
                            onClicked: () => context.unlock()
                        }
                    }
                }
            }
        }
    }
}
