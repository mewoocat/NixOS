
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Clock } from '../Modules/datetime.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Gtk from 'gi://Gtk';
import { NotificationWidget } from './NotificationPopup.js';
import Media from '../Modules/Media.js';

// More info https://aylur.github.io/ags-docs/config/subclassing-gtk-widgets/
const calendar = new Gtk.Calendar({
    showDayNames: false,
    showHeading: true,
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

const players = Widget.Box({
    children: mpris.bind('players').transform(p => p.map(Player))
})

const container = () => Widget.Box({
    class_name: "control-panel-container",
    spacing: 8,
    vertical: true,
    children: [
        calendar,
        players,
        NotificationWidget,
        //Media(), //Borked :(
    ],
});


export const ActivityCenterButton = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t ActivityCenter'),
    child:
        Clock()
});

export const ActivityCenter = (monitor = 0) => Widget.Window({
    name: `ActivityCenter`, // name has to be unique
    class_name: 'control-panel',
    visible: false,
    focusable: true,
    popup: true,
    monitor,
    anchor: ['top', 'center'],
    exclusivity: 'normal',
    child: Widget.Box({
        children: [container()]
    }),
});