pragma Singleton
import Quickshell

Singleton {
    function secToMinAndSec(seconds: int): string {
        const minutes = Math.floor(seconds / 60)
        var leftoverSeconds = Math.floor(seconds % 60)
        if (leftoverSeconds < 10) {leftoverSeconds = `0${leftoverSeconds}`}
        return `${minutes}:${leftoverSeconds}`
    }

    function formatTime(seconds: int): string {
        var hours = Math.floor(seconds / 60 / 60)
        var minutes = Math.floor(seconds / 60) - (hours * 60)
        if (minutes < 10) minutes = `0${minutes}`
        var seconds = seconds - (hours * 60 * 60) - (minutes * 60)
        if (seconds < 10) seconds = `0${seconds}`

        return `${hours}:${minutes}:${seconds}`
    }
}
