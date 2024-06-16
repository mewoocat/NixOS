#!/usr/bin/env -S ags -b "settings" -c

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { RefreshWifi, WifiSSID, WifiIcon, WifiList, APInfo } from '../Modules/Network.js';
import { PowerProfilesButton } from '../Modules/Power.js';

const { Gtk } = imports.gi;

const Window = Widget.subclass(Gtk.Window, "Window");

const SettingsTab = Variable("general", {})

const tabs = [
    "general",
    "appearance",
    "network",
    "bluetooth",
    "devices",
    "about",

]

const Tab = (t) => Widget.Button({
    class_name: "normal-button",
    on_primary_click: () =>{
        print(t)
        SettingsTab.value = t
    },
    child: Widget.Label({
        css: `
        `,
        label: t,
    }),

})

const Tabs = () => Widget.Box({
    vertical: true,
    children: tabs.map(Tab)
})

const GeneralContainer = () => Widget.Box({
    vertical: true,
    css: `
    `,
    hexpand: true,
    children: [
        Widget.Label({
            label: "General",
        }),
        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        Widget.Label({
            label: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
            wrap: true,
        }),
        PowerProfilesButton(),
    ],
})

const NetworkContainer = () => Widget.Box({
    vertical: true,
    css: `
    `,
    hexpand: true,
    children: [
        Widget.Label({
            label: "General",
        }),

        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        Widget.Label({
            label: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
            wrap: true,
        }),
        WifiList(),

    ],
})

const TabContainer = () => Widget.Stack({      
    // Tabs
    children: {
        'general': GeneralContainer(),
        'network': NetworkContainer(),
    },
    transition: "slide_up_down",

    // Select which tab to show
    setup: self => self.hook(SettingsTab, () => {
        self.shown = SettingsTab.value;
    })
})

Window({
  child: Widget.Box({
    children: [
        Tabs(),
        TabContainer(),
    ],
  }),
  setup: (self) => {
    self.show_all();

    self.on("destroy", App.quit);
  },
});

App.config({
});
