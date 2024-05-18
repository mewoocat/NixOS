#!/usr/bin/env -S ags -b "settings" -c

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
const { Gtk } = imports.gi;

const Window = Widget.subclass(Gtk.Window, "Window");

Window({
  child: Widget.Box({
    children: [
        Widget.Label({
            css: `
                min-width: 10rem;
                min-height: 10rem;
                background-color: red;
            `,
            label: "hii",
        }),
    ],
  }),
  setup: (self) => {
    self.show_all();

    self.on("destroy", App.quit);
  },
});

App.config({
});
