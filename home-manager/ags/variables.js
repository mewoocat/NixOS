import Variable from 'resource:///com/github/Aylur/ags/variable.js';

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
