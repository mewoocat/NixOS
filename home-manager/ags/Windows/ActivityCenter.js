
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Clock } from '../Modules/datetime.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Gtk from 'gi://Gtk';
import { NotificationWidget } from './NotificationPopup.js';
import Media from '../Modules/Media.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { CloseOnClickAway } from '../Common.js';

// More info https://aylur.github.io/ags-docs/config/subclassing-gtk-widgets/

const calendar = Widget.Calendar({ 
    showDayNames: false,
    showHeading: true,
    hpack: "center",
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

const isOpenA = Variable(false)

function toggleReveal(){
    console.log(isOpenA.value)
    if (isOpenA.value == false){
        isOpenA.value = true
    }
    else{
        isOpenA.value = false
    }
}

const container = () => Widget.Box({
    css: `
        padding: 1px;
    `,
    child:
        Widget.Revealer({
            revealChild: false,
            transitionDuration: 150,
            transition: 'slide_down',
            setup: self => {
                self.hook(App, (self, windowName, visible) => {
                    if (windowName === "ActivityCenter"){
                        self.revealChild = visible
                    }
                }, 'window-toggled')
            },

            child:
                Widget.Box({
                    class_name: "control-panel-container",
                    css: `
                        min-width: 600px;
                        padding: 1rem;
                    `,
                    spacing: 8,
                    children: [
                        Widget.Box({
                            children:[
                                calendar,
                            ]
                        }),
                        Widget.Box({
                            vertical: true,
                            children: [
                                players,
                                NotificationWidget,
                            ]
                        })
                        //Media(), //Borked :(
                    ],
                })
        })
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
    monitor,
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    exclusivity: 'normal',
    child: CloseOnClickAway("ActivityCenter", container(), "top-center"),
});
