import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';

// TODO The bind prop is deprecated change to using the .bind()
export const SysTray = () => Widget.Box({
    children: SystemTray.bind('items').transform(items => {
        return items.map(item => Widget.Button({
            child: Widget.Icon().bind('icon', item, 'icon'),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltipMarkup: item.bind('tooltip_markup'),
        }).hook(SystemTray, self => {
            self.icon = item.icon
        }, "changed"));
    }),

});
