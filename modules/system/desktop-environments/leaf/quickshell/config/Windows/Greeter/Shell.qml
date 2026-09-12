import Quickshell
import "../../Components/Controls" as Ctrls
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Greetd

ShellRoot {
    PanelWindow {
        focusable: true
        anchors {
            left: true
            right: true
            bottom: true
            top: true
        }
        color: "#101010"
        ColumnLayout {
            anchors.centerIn: parent
            Text {
                text: `greetd socket available: ${Greetd.available}\n state: ${GreetdState.toString(Greetd.state)}`
            }
            TextField {
                id: user
                focus: true
                placeholderText: "username..."
            }
            TextField {
                id: pass
                placeholderText: "password..."
                echoMode: TextInput.Password
            }
            Button {
                text: 'launch'
                onClicked: {
                    Greetd.createSession(`${user.text}`)
                }
            }
        }

        Connections {
            target: Greetd
            function onAuthMessage(msg, err, resReq, echoRep) {
                Greetd.respond(pass.text)
            }

            function onReadyToLaunch() {
                Greetd.launch(['niri-session'])
            }
        }
    }
}
