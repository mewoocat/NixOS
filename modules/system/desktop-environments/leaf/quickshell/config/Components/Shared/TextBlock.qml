import QtQuick
import qs as Root

Text {
    color: Root.State.colors.on_surface
    padding: 4
    elide: Text.ElideRight // Truncate with ... on the right
}
