import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { currentTemp, hiTemp, loTemp, weatherStatus, precipitation, humidity, weather } from '../variables.js'


export const Weather = (w, h) => Widget.Box({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
        background-image: url("/home/eXia/Downloads/clear.jpg");
    `,
    children: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            vpack: "center",
            spacing: 4,
            children: [
                //Temperature
                Widget.Box({
                    children:[
                        // Current temp
                        Widget.Label({
                            hexpand: true,
                            css: `
                                font-size: 1.4rem;
                            `,
                            label: currentTemp.bind()
                        }),
                        Widget.Box({
                            vertical: true,
                            hexpand: true,
                            css: `
                                font-size: 0.8rem;
                            `,
                            children: [
                                // Hi
                                Widget.Label({
                                    hpack: "start",
                                    label: hiTemp.bind(),
                                }),
                                // Lo
                                Widget.Label({
                                    hpack: "start",
                                    label: loTemp.bind(),
                                }),

                            ]
                        })
                    ]
                }),
                // Status
                Widget.Label({
                    label: weatherStatus.bind()
                }),
                Widget.Box({
                    children: [
                        // Precipitation
                        Widget.Label({
                            hexpand: true,
                            label: precipitation.bind()
                        }),
                        // Humidity
                        Widget.Label({
                            hexpand: true,
                            label: humidity.bind()
                        }),
                    ]
                }),
            ]
        })
    ]
}) 
