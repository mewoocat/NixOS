import Widget from 'resource:///com/github/Aylur/ags/widget.js';

const NotWorking = () => Widget.Button({
    class_name: 'media',
    on_primary_click: () => Mpris.getPlayer('')?.playPause(),
    on_scroll_up: () => Mpris.getPlayer('')?.next(),
    on_scroll_down: () => Mpris.getPlayer('')?.previous(),
    child: Widget.Label('-').hook(Mpris, self => {
        if (Mpris.players[0]) {
            const { track_artists, track_title } = Mpris.players[0];
            self.label = `${track_artists.join(', ')} - ${track_title}`;
        } else {
            self.label = 'Nothing is playing';
        }
    }, 'player-changed'),
});

const mpris = await Service.import('mpris')

/** @param {import('types/service/mpris').MprisPlayer} player */
const Player = player => Widget.Button({
    onClicked: () => player.playPause(),
    child: Widget.Label().hook(player, label => {
        const { track_artists, track_title } = player;
        label.label = `${track_artists.join(', ')} - ${track_title}`;
    }),
})

export const Media = Widget.Box({
    children: mpris.bind('players').transform(p => p.map(Player))
})
