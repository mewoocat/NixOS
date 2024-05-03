import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Gdk from 'gi://Gdk';

/**
  * @param {number} length
  * @param {number=} start
  * @returns {Array<number>}
  */
export function range(length, start = 1) {
    return Array.from({ length }, (_, i) => i + start);
}

/**
  * @param {(monitor: number) => any} widget
  * @returns {Array<import('types/widgets/window').default>}
  */
export function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 0;
    // Creates a new array from the array of monitor numbers using the widget as a function for each number
    return range(n, 0).map(widget).flat(1);
}
