import App from 'resource:///com/github/Aylur/ags/app.js';

const entry = App.configDir + '/main.ts'
//const entry = '/home/eXia/NixOS/modules/system/desktop-environments/leaf/ags/ags-config/main.ts' // For development
const outdir = '/tmp/ags/js'

try {
    await Utils.execAsync([
        'bun', 'build', entry,
        '--outdir', outdir,
        '--external', 'resource://*',
        '--external', 'gi://*',
    ])
    await import(`file://${outdir}/main.js`)
} catch (error) {
    console.error(error)
}
