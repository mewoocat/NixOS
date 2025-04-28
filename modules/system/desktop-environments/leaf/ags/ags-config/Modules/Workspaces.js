import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'
import * as Log from '../Lib/Log.js'
import * as Helper from '../Lib/Helper.ts'

const NUM_WORKSPACES = 10
const WS_WIDGET_WIDTH = 16 // In rem

const dispatch = ws => Hyprland.sendMessage(`dispatch workspace ${ws}`);

export const Workspaces = () => Widget.EventBox({
    onScrollUp: () => dispatch('+1'),
    onScrollDown: () => dispatch('-1'),
    child: Widget.Box({
        children: Array.from({ length: NUM_WORKSPACES }, (_, i) => i + 1).map(i => Widget.Button({
            class_name: "ws-button",
            attribute: i,
            // Keeps button from expanding to fit its container
            onClicked: () => dispatch(i),
            child: Widget.Box({
                class_name: "ws-indicator",
                // vpack: "start",
                vpack: "center",
                hpack: "center",
                children: [
                    Widget.Label({
                        label: `${i}`,
                        justification: "center",
                    })
                ],
                setup: self => self.hook(Hyprland, () => {
                    // The "?" is used here to return "undefined" if the workspace doesn't exist
                    self.toggleClassName('ws-inactive', (Hyprland.getWorkspace(i)?.windows || 0) === 0);
                    self.toggleClassName('ws-occupied', (Hyprland.getWorkspace(i)?.windows || 0) > 0);
                    self.toggleClassName('ws-active', Hyprland.active.workspace.id === i);
                    self.toggleClassName('ws-large', (Hyprland.getWorkspace(i)?.windows || 0) > 1);
                }),
            }),
        })),
    }),
});

export const SpecialWorkspace = () => Widget.Label({
    label: "test", 
}).hook(Hyprland, self => {
    //print(Hyprland.active.workspace.id)
    if (Hyprland.active.workspace.id == -99){
        self.label = "special"
    }
    else {
        self.label = "not"
    }
})



export const WorkspaceGrid = () => {

    // Map of workspace id to widget
    let wsMap = {}

    const widget = Widget.FlowBox({
        css: `
            min-width: 1000px;
        `,
        //max_children_per_line: 3,
        row_spacing: 8,
        column_spacing: 8,
    })

    // Map of monitor id's to their sizes
    let monitorsSizes = {}
    for (const m of Hyprland.monitors) {
        monitorsSizes[m.id] = {w: m.width, h: m.height}
    }

    // Workspace widget box
    const workspaceContainer = (id) => {
        Log.Info(`workspace id: ${id}`)
        const ws = Hyprland.getWorkspace(id)
        // Workspace hasn't been created yet
        if (ws === undefined) {
            return null
        }
        const monitorSize = monitorsSizes[ws.monitorID]
        const aspectRatio = monitorSize.h / monitorSize.w
        const size = {w: WS_WIDGET_WIDTH, h: WS_WIDGET_WIDTH * aspectRatio}
        return Widget.FlowBox({     
            class_name: "ws-box",
            css: `
                min-width: ${size.w}rem;
                min-height: ${size.h}rem;
            `,
        })
    }

    // Takes in an existingWorkspaces array of workspace widgets
    const GenerateWorkspaces = () => {

        const clientButton = (clientAddress = null) => {
            const client = Hyprland.getClient(clientAddress)
            return Widget.Box({
                attribute: {
                    client: client
                },
                children: [
                    Widget.Button({
                        class_name: "normal-button",
                        tooltip_text: client.title,
                        on_primary_click_release: (self) => {
                            // Focus client
                        },
                        child: Widget.Box({
                            vertical: true,
                            children: [
                                Widget.Box({
                                    children: [
                                        Widget.Icon({
                                            class_name: 'client-icon',
                                            css: 'font-size: 2.4rem;',
                                            icon: Helper.lookupClientIcon(client.class),
                                        }),         
                                    ],
                                }),
                                Widget.Label({
                                    label: Helper.formatClientName(client.class),
                                    class_name: 'small-text',
                                    truncate: 'end',
                                    maxWidthChars: 8,
                                })                
                            ]
                        })
                    })
                ]
            })
        }

        // Init all workspaces
        for(let i = 1; i <= NUM_WORKSPACES; i++) {
            Log.Info(`i = ${i}`)
            const ws = workspaceContainer(i)
            if (ws !== null) {
                wsMap[i] = ws
                widget.add(ws)
            }
        }
        
        for (const c of Hyprland.clients) {
            const button = clientButton(c.address) 
            const wsID = c.workspace.id
            Log.Info(`----------------`)
            Log.Info(`wsID = ${wsID}`)
            Log.Info(`wsMap[wsID] = ${wsMap[wsID]}`)
            if (wsMap[wsID] !== undefined){
                wsMap[wsID].add(button)
            }
        }

    }


    GenerateWorkspaces()
    return widget

}

