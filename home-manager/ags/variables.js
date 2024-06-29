import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

const divide = ([total, free]) => free / total;

export const GPUTemp = Variable(0, {
    poll: [1000, ['bash', '-c', "gpustat --no-header | grep '\[0\]' | cut -d '|' -f 2 | cut -d ',' -f 1 | cut -c -3"], out => Math.round(parseInt(out))/100]
    //poll: [1000, ['bash', '-c', ""], out => Math.round(parseInt(out))/100]
})

export const cpu = Variable(0, {
    poll: [1000, ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"], out => Math.round(out)/100]
})

export const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

// Cpu temp
export const temp = Variable(-1, {
    poll: [6000, ['bash', '-c', "fastfetch --packages-disabled nix --logo none --cpu-temp | grep 'CPU:' | rev | cut -d ' ' -f1 | cut -c 4- | rev"], out => Math.round(out)
]});

// Percent of storage used on '/' drive
//TODO -t ext4 is a workaround the "df: /run/user/1000/doc: Operation not permitted" error which is returning a non zero value which might be causing it not to work
export const storage = Variable(0, {
    poll: [5000, 'df -h -t ext4', out => out.split('\n')
        .find(line => line.endsWith("/"))
        .split(/\s+/).slice(-2)[0]
        .replace('%', '')
    ]
});

export const user = Variable("...", {
    poll: [60000, 'whoami', out => out]
});

export const uptime = Variable("...", {
    poll: [60000, 'uptime', out => out.split(',')[0]]
});


// Window states
export const isLauncherOpen = Variable(false)



