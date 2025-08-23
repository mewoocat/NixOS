import QtQuick
import Quickshell.Services.Pipewire
import qs.Services as Services

BarButton {
    iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
}
