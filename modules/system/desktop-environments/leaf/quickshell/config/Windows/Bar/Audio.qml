import QtQuick
import Quickshell.Services.Pipewire
import "../../" as Root
import "../../Services" as Services
import "../../Modules/Common" as Common

Common.NormalButton {
    iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
}
