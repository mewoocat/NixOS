import Variable from 'resource:///com/github/Aylur/ags/variable.js';

const divide = ([total, free]) => free / total;

export const cpu = Variable(0, {
    poll: [2000, 'top -b -n 1', out => divide([100, out.split('\n')
        .find(line => line.includes('Cpu(s)'))
        .split(/\s+/)[1]
        .replace(',', '.')])],
});

export const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

// Cpu temp
export const temp = Variable(0, {
    poll: [2000, 'sensors', out => out.split('\n')
        .find(line => line.includes('Package'))
        .split(/\s+/)[3]
        .slice(1,-2)
]});

// Percent of storage used on '/' drive
export const storage = Variable(0, {
    poll: [2000, 'df -h', out => out.split('\n')
        //TODO have this regex for "/" device
        //.find(line => line.includes("/dev/nvme0n1p1"))
        .find(line => line.endsWith("/"))
        .split(/\s+/)[4]
]});