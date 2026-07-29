import Quickshell
import "../../Components/Controls" as Ctrls
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Greetd

ShellRoot {
    FloatingWindow {
        color: "red"
        ColumnLayout {
            Text {
                text: "greetd socket available: " + Greetd.available 
            }
            Text {
                text: `state: ${GreetdState.toString(Greetd.state)}`
            }
            Button {
                text: 'create sessions'
                onClicked: {
                    Greetd.createSession("eXia")
                }
            }
            Button {
                text: 'launch'
                onClicked: {
                    Greetd.launch(['niri-session'])
                }
            }
            TextField {
                id: pass
            }
        }

        Connections {
            target: Greetd
            function onAuthMessage(msg, err, resReq, echoRep) {
                Greetd.respond(pass.text)
            }
        }
    }
}
