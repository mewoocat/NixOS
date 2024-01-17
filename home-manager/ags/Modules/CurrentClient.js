import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

export const ClientTitle = () => Widget.Label({
    class_name: 'client-title',
    label: Hyprland.active.client.bind('class'),
});

export const ClientIcon = () => Widget.Icon({
    class_name: 'client-icon',
    icon: Hyprland.active.client.bind("class"),
})