import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

const dispatch = ws => Hyprland.sendMessage(`dispatch workspace ${ws}`);

export const Workspaces = () => Widget.EventBox({
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        children: Array.from({ length: 10 }, (_, i) => i + 1).map(i => Widget.Button({
            cursor: "pointer",
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