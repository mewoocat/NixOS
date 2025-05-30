import QtQuick
import Quickshell.Services.Pipewire
import "root:/" as Root
import "root:/Services" as Services
import "root:/Modules/Common" as Common

Common.NormalButton {
    iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
}
