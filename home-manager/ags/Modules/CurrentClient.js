import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

export const ClientTitle = () => Widget.Label({
    class_name: 'client-title',
    label: Hyprland.active.client.bind('class').as(v => v[0].toUpperCase() + v.slice(1)),
});

export const ClientIcon = () => Widget.Icon({
    class_name: 'client-icon',
    }).bind('icon', Hyprland, 'active', p => {
        const icon = Utils.lookUpIcon(p.client.class)

        //icon: Hyprland.active.client.bind("class"),
        if (icon) {
            // icon is the corresponding Gtk.IconInfo
            return p.client.class
            
        }
        else {
            // null if it wasn't found in the current Icon Theme
            // Return place holder icon
            return "AppImageLauncher" 
        }
})
