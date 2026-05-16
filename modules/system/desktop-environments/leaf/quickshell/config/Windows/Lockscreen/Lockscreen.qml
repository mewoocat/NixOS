pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

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
                color: "black"
                Rectangle {
                    color: Root.State.colors.surface
                    anchors.centerIn: parent
                    width: 300
                    height: 200
                    radius: Root.State.rounding
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 20
                        ColumnLayout {
                            spacing: 0
                            Text {
                                color: Root.State.colors.on_surface
                                text: Services.DateTime.date
                            }
                            Text {
                                text: Services.DateTime.time
                                color: Root.State.colors.on_surface
                                font.pointSize: 24
                            }
                        }
                        RowLayout {
                            Ctrls.TextField {
                                focus: true
                                onTextChanged: context.currentText = text
                                onAccepted: context.unlock()
                                echoMode: TextInput.Password
                            }
                            Ctrls.Button {
                                text: "unlock"
                                onClicked: () => context.unlock()
                            }
                        }
                    }
                }
            }
        }
    }
}
