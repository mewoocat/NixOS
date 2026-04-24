// This file is used to expose internal functions to the cli

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import * as Dock from './Windows/Dock.js';

console.log("what")

export const minimizeActiveClient = () => {
    Dock.toggleClient(Hyprland.active.client.address)
}

globalThis.minimizeActiveClient = minimizeActiveClient
