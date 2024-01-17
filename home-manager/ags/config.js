import { applauncher } from './applauncher.js';
import { bar } from './Windows/bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';

export default {
    style: '.config/ags/style.css',
    windows: [applauncher, bar(), ControlPanel(),],
};
