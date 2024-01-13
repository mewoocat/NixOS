import { applauncher } from './applauncher.js';
import { bar } from './bar.js';
import { ControlPanel } from './ControlPanel.js';

export default {
    style: './style.css',
    windows: [applauncher, bar(), ControlPanel(),],
};
