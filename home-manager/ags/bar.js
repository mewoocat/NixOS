import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
//import Service from 'resource:///com/github/Aylur/ags/service.js';

import Brightness from './Services/brightness.js'

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

const Launcher = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t applauncher'),
    child:
        Widget.Label({
            label: "A"
        }) 
});

const dispatch = ws => Hyprland.sendMessage(`dispatch workspace ${ws}`);

const Workspaces = () => Widget.EventBox({
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            class_name: 'ws-button',
            attribute: i,
            label: `${i}`,
            onClicked: () => dispatch(i),

            setup: self => self.hook(Hyprland, () => {
                // The "?" is used here to return "undefined" if the workspace doesn't exist
                self.toggleClassName('occupied-ws', (Hyprland.getWorkspace(i)?.windows || 0) > 0);
                self.toggleClassName('active-ws', Hyprland.active.workspace.id === i);
            }),
        })),

        // remove this setup hook if you want fixed number of buttons
        // Not working
        /*
        setup: self => self.hook(Hyprland, () => box.children.forEach(btn => {
            btn.visible = Hyprland.workspaces.some(ws => ws.id === btn.attribute);
        })),
        */
    }),
});

const ClientTitle = () => Widget.Label({
    class_name: 'client-title',
    label: Hyprland.active.client.bind('title'),
});

const Clock = () => Widget.Label({
    class_name: 'clock',
    setup: self => self
        // this is bad practice, since exec() will block the main event loop
        // in the case of a simple date its not really a problem
        //.poll(1000, self => self.label = exec('date "+%H:%M:%S %b %e."'))

        // this is what you should do
        .poll(1000, self => execAsync(['date', '+%B %e   %l:%M %P'])
            .then(date => self.label = date)),
});

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
const Notification = () => Widget.Box({
    class_name: 'notification',
    visible: Notifications.bind('popups').transform(p => p.length > 0),
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
        }),
        Widget.Label({
            label: Notifications.bind('popups').transform(p => p[0]?.summary || ''),
        }),
    ],
});

const Media = () => Widget.Button({
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

const Volume = () => Widget.Box({
    class_name: 'volume',
    css: 'min-width: 180px',
    children: [
        Widget.Icon().hook(Audio, self => {
            if (!Audio.speaker)
                return;

            const category = {
                101: 'overamplified',
                67: 'high',
                34: 'medium',
                1: 'low',
                0: 'muted',
            };

            const icon = Audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
                threshold => threshold <= Audio.speaker.volume * 100);

            self.icon = `audio-volume-${category[icon]}-symbolic`;
        }, 'speaker-changed'),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed'),
        }),
    ],
});


const brightness = () => Widget.Box({
    class_name: 'brightness',
    css: 'min-width: 180px',
    children: [
        Widget.Label({
            //label: Brightness.bind('screen-value').transform(v => `${v}`),
            setup: self => self.hook(Brightness, (self, screenValue) => {
                // screenValue is the passed parameter from the 'screen-changed' signal
               // self.label = screenValue ?? 0;

                // NOTE:
                // since hooks are run upon construction
                // the passed screenValue will be undefined the first time

                // all three are valid
                //self.label = `${Brightness.screenValue}`;
                //self.label = `${Brightness.screen_value}`;
                //self.label = `${Brightness['screen-value']}`;
                self.label = '*'

            }, 'screen-changed'),
        }),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: self => Brightness.screen_value = self.value,
            value: Brightness.bind('screen-value'),
        }),
    ],
});

const BatteryLabel = () => Widget.Box({
    class_name: 'battery',
    visible: Battery.bind('available'),
    children: [

        Widget.Overlay({
            child:
                Widget.Label({
                    // Not sure what transform does here 
                    label: Battery.bind('percent').transform(p => {
                        return ""
                    })
                }),
            overlays: [
                Widget.Label({
                    // Not sure what transform does here 
                    label: Battery.bind('percent').transform(p => {
                        return ""
                    })
                }),
            ]
        }),



        Widget.Label({
            // Not sure what transform does here 
            label: Battery.bind('percent').transform(p => {
                return p.toString()
            })
        }),
    ],
});


// TODO The bind prop is deprecated change to using the .bind()
const SysTray = () => Widget.Box({
    children: SystemTray.bind('items').transform(items => {
        return items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }),
});

const ControlPanel = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t ControlPanel'),
    child:
        Widget.Label({
            label: "B"
        }) 
});

// layout of the bar
const Left = () => Widget.Box({
    spacing: 8,
    children: [
        Launcher(),
        Workspaces(),
        //ClientTitle(),
    ],
});

const Center = () => Widget.Box({
    spacing: 8,
    children: [
        Clock(),
        //Media(),
        Notification(),
    ],
});

const Right = () => Widget.Box({
    hpack: 'end',
    spacing: 8,
    children: [
        //SysTray(), // See comments at func. declaration
        brightness(),
        Volume(),
        BatteryLabel(), 
        ControlPanel(),
    ],
});

export const bar = (monitor = 0) => Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
    }),
});

import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

// Does this just watch for css changes to then reload them?
monitorFile(
    `${App.configDir}/style.css`,
    function() {
        App.resetCss();
        App.applyCss(`${App.configDir}/style.css`);
    },
);
