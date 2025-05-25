import QtQuick
import Quickshell.Services.Pipewire
import "root:/" as Root
import "root:/Services" as Services
import "root:/Modules/Ui" as Ui

Ui.NormalButton {
    iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
}
