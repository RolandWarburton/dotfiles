import { $ } from 'zx';
import chalk from 'chalk';
import YAML from 'yaml';
import { dirname, resolve } from 'path';
import { fileURLToPath } from 'url';
import { readFileSync } from 'fs';
import { homedir } from 'os';
import { spawn } from 'child_process';
import { EventEmitter } from 'events';
const shell_events = new EventEmitter();
const __dirname = dirname(fileURLToPath(import.meta.url));
// store the default zx quote style
const q = $.quote;
// make zx silent
$.verbose = false;
const logStatus = (msg, status) => status
    ? console.log(chalk.bgGreen(`[YES]`) + ` ${msg}`)
    : console.log(chalk.bgRed(`[NO]`) + ` ${msg}`);
// console.log(chalk.bgGreen(`[${status ? 'YES' : 'NO'}]`) + ' ' + msg);
async function main(config) {
    console.log('Collecting information about the environment');
    const isGraphicalEnvironment = (await $ `type Xorg`.exitCode) === 0 ? true : false;
    const isDebian11 = (await $ `cat /etc/debian_version`.exitCode) === 0 ? true : false;
    const isConnectedToInternet = (await $ `ping -c 1 google.com`.exitCode) === 0 ? true : false;
    const isPython3Installed = (await $ `python3 -V`.exitCode) === 0 ? true : false;
    const isPython3PipInstalled = (await $ `python3 -m pip -V`.exitCode) === 0 ? true : false;
    const isDotbotInstalled = (await $ `which dotbot`.exitCode) === 0 ? true : false;
    const isCurlInstalled = (await $ `which curl`.exitCode) === 0 ? true : false;
    logStatus('graphical environment', isGraphicalEnvironment);
    logStatus('Debian 11', isDebian11);
    logStatus('connected to internet', isConnectedToInternet);
    logStatus('python3 installed', isPython3Installed);
    logStatus('python3 pip installed', isPython3PipInstalled);
    logStatus('dotbot installed', isDotbotInstalled);
    logStatus('curl installed', isCurlInstalled);
    let hasInstalledPackages = config?.progress?.hasInstalledPackages;
    // update packages if elected for in the config
    console.log('Running system update...');
    $.verbose = true;
    if (config?.apt?.updatePackages) {
        await $ `sudo apt-get update`;
    }
    if (config?.apt?.upgradePackages) {
        await $ `apt-get upgrade -y`;
    }
    $.verbose = false;
    // collect information about packages
    const packages = YAML.parse(readFileSync(resolve(__dirname, config.packages), 'utf8'));
    console.log('Installing package groups\n' +
        Object.keys(packages)
            .map((e) => '- ' + e)
            .join('\n'));
    for (const group in packages) {
        for (const pkg of Object.keys(packages[group])) {
            // install the package if it appears not installed
            if ((await $ `dpkg -l ${pkg}`.exitCode) !== 0) {
                await $ `sudo apt-get install -y ${pkg}`;
                console.log(chalk.green(`Installed ${pkg}`));
                // check if there is postInstall commands to run
                if (packages[group][pkg]?.postInstall) {
                    console.log(`Running post install for ${pkg}`);
                    for (const cmd of packages[group][pkg].postInstall) {
                        $.verbose = true;
                        $.quote = (v) => v;
                        await $ `${cmd}`;
                        $.quote = q;
                        $.verbose = false;
                    }
                }
            }
            else {
                console.log(chalk.gray(`${pkg} already installed`));
            }
        }
    }
    // install dotbot if not already isntalled
    if (!isPython3Installed || !isPython3PipInstalled || !isDotbotInstalled) {
        console.log('Installing dotbot');
        $.verbose = true;
        $.quote = (v) => v;
        await $ `apt install python3`;
        await $ `apt install python3-pip`;
        await $ `pip3 install dotbot`;
        $.quote = q;
        $.verbose = false;
    }
    $.quote = (v) => v;
    await $ `dotbot -c ${config.dotbotConfig}`;
    $.quote = q;
    if (!isCurlInstalled) {
        console.log('Installing curl');
        $.verbose = true;
        $.quote = (v) => v;
        await $ `sudo apt install curl`;
        $.quote = q;
        $.verbose = false;
    }
    // install zplug
    $.verbose = true;
    await $ `rm -rf ${homedir()}/.zplug`;
    await $ `curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh`;
    const zshell = spawn('/usr/bin/zsh', { shell: false });
    zshell.stdin.setDefaultEncoding('utf-8');
    // zshell.stdout.on('data', (data) => {
    //   console.log(data.toString());
    //   if (data.toString().includes('Installation finished successfully')) {
    //     console.log('KILLING ZSH');
    //     zshell.stdin.end();
    //     console.log('ended stdin');
    //     zshell.stdin.write('exit\n');
    //     console.log('exited zsh');
    //     // zshell.kill();
    //     // console.log('killed zsh');
    //     // console.log(zshell.pid);
    //     // exec(`kill ${zshell.pid}`);
    //     // console.log('executed kill');
    //     // =========================
    //     // console.log('KILLING ZSH');
    //     // zshell.stdin.end();
    //     // console.log('ended stdin');
    //     // zshell.stdin.write('exit\n');
    //     // console.log('exited zsh');
    //     // zshell.kill();
    //     // console.log('killed zsh');
    //     // console.log(zshell.pid);
    //     // exec(`kill ${zshell.pid}`);
    //     // console.log('executed kill');
    //   }
    // });
    zshell.stderr.on('data', (data) => {
        console.log(`stderr: ${data}`);
    });
    zshell.on('close', (code) => {
        console.log(`child process exited with code ${code}`);
    });
    zshell.on('exit', (code) => {
        console.log(`child process exit exited with code ${code}`);
        zshell.stdout.destroy();
        zshell.stderr.destroy();
        zshell.stdin.destroy();
        // zshell.stdin.destroy();
        // zshell.stdin.end();
        // console.log('ended stdin');
        // zshell.stdin.write('exit\n');
        // console.log('exited zsh');
        // zshell.stdin.write('exit\n');
        // zshell.kill();
        // zshell.kill('SIGTERM');
        // console.log(zshell.killed);
        // zshell.unref();
        // zshell.removeAllListeners();
    });
    zshell.stdout.on('data', (data) => {
        console.log(data.toString());
        if (data.toString().includes('Installation finished successfully')) {
            shell_events.emit('zplug-installed-plugins');
        }
    });
    setTimeout(() => {
        zshell.stdin.write(`source ${homedir()}/.zplug/init.zsh\n`);
    }, 100);
    setTimeout(() => {
        zshell.stdin.write(`source ${homedir()}/.zshrc\n`);
    }, 200);
    setTimeout(() => {
        console.log('sending zplug install');
        zshell.stdin.write(`zplug install >/dev/null && echo 0 > temp\n`);
    }, 300);
    shell_events.on('zplug-installed-plugins', () => {
        zshell.stdin.end();
        // zshell.stdin.end();
        // console.log('ended stdin');
    });
    // setTimeout(() => {
    //   zshell.stdin.write(`zplug list\n`);
    //   zshell.stdin.end();
    // }, 5000);
    // setTimeout(() => {
    //   zshell.stdin.write(`zplug install\n`);
    //   zshell.stdin.end();
    // }, 5000);
    // kill
    // shell_events.on('zplug-installed-plugins', () => {
    //   zshell.stdin.end();
    //   console.log('ended stdin');
    //   zshell.stdin.write('exit\n');
    //   console.log('exited zsh');
    //   // setTimeout(() => {
    //   //   zshell.stdin.write('exit\n');
    //   //   console.log('exited zsh');
    //   // }, 500);
    //   // setTimeout(() => {
    //   //   zshell.stdin.end();
    //   //   console.log('ended');
    //   // }, 1000);
    //   // setTimeout(() => {
    //   //   if (zshell.pid) {
    //   //     spawn('kill', [zshell.pid.toString()]);
    //   //     console.log('killed again');
    //   //   }
    //   // }, 1500);
    //   // =====
    //   // zshell.stdin.end();
    //   // console.log('ended stdin');
    //   // zshell.stdin.write('exit\n');
    //   // console.log('exited zsh');
    // });
    $.verbose = false;
    console.log('done here');
}
export { main };
//# sourceMappingURL=ignoreMe.js.map