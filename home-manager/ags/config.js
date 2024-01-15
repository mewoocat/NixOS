import { applauncher } from './applauncher.js';
import { bar } from './bar.js';
import { ControlPanel } from './ControlPanel.js';

export default {
    style: '.config/ags/style.scss',
    windows: [applauncher, bar(), ControlPanel(),],
};
