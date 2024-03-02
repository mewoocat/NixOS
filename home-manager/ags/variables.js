import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';

const divide = ([total, free]) => free / total;

export const cpu = Variable(0, {
    poll: [2000, 'top -b -n 1', out => 1 - divide([100, out.split('\n')
        .find(line => line.includes('CPU:'))
        .split(/\s+/)[7]
        .replace('%', '')])
    ],
});

export const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

// Cpu temp
/*
export const temp = Variable(0, {
    poll: [2000, 'sensors', out => out.split('\n')
        .find(line => line.includes('Package'))
        .split(/\s+/)[3]
        .slice(1,-2)
]});
*/

// Percent of storage used on '/' drive
//TODO -t ext4 is a workaround the "df: /run/user/1000/doc: Operation not permitted" error which is returning a non zero value which might be causing it not to work
export const storage = Variable(0, {
    poll: [5000, 'df -h -t ext4', out => out.split('\n')
        .find(line => line.endsWith("/"))
        .split(/\s+/).slice(-2)[0]
        .replace('%', '')
    ]
});


export const ControlPanelTab = Variable("child1", {})


import App from 'resource:///com/github/Aylur/ags/app.js';
// Read in user settings
const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))

var lat = data.lat
print("lat: " + lat)
var lon = data.lon
print("lon: " + lon)
//TODO add variables for units
var url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,apparent_temperature,precipitation,weather_code&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch`

// Get data from api
async function getWeather(){
    // await is needed to wait for the return of the data
    const data = await Utils.fetch(url)
        .then(res => res.json())
        .catch(console.error)

    print(data.current.temperature_2m)
    return data
}

export const weather = Variable(getWeather(), {
    poll: [400000, () => { return getWeather() }]
})


export const user = Variable("...", {
    poll: [60000, 'whoami', out => out]
});

export const uptime = Variable("...", {
    poll: [60000, 'uptime', out => out.split(',')[0]]
});


// Window states
export const isLauncherOpen = Variable(false)



