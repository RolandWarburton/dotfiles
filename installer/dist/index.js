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
    console.log('Configuring locale');
    $.quote = (v) => v;
    $.verbose = true;
    await $ `su - && "echo LC_ALL=en_US.UTF-8 >> /etc/environment"`;
    // await $`sudo echo LANG=en_US.UTF-8 >> /etc/environment`;
    // await $`sudo echo LANGUAGE=en_US.UTF-8 >> /etc/environment`;
    // await $`sudo locale-gen en_US.UTF-8`;
    $.verbose = false;
    $.quote = q;
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
    console.log(`${chalk.bgGreen('[DONE]')} Installed all packages`);
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
    const dotbotResult = await $ `dotbot -c ${config.dotbotConfig}`;
    console.log(`${chalk.bgGreen(`[DONE]`)} Dotbot finished with code ${dotbotResult.exitCode}`);
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
    });
    zshell.stdout.on('data', (data) => {
        // wait for the installation to finish
        if (RegExp(/^INFO/).test(data.toString())) {
            console.log(data.toString());
        }
        if (data.toString().includes('INSTALLATION COMPLETE')) {
            shell_events.emit('zplug-installed-plugins');
        }
    });
    zshell.stdin.write(`
  echo "INFO: Initializing zplug" &&
  source ${homedir()}/.zplug/init.zsh &&
  echo "INFO: Installing zshrc" &&
  source ${homedir()}/.zshrc &&
  echo "INFO: Installing zplug plugins" &&
  zplug install >/dev/null &&
  echo "INSTALLATION COMPLETE"\n
  `);
    // wait for the zplug installation to finish
    await new Promise((resolve) => {
        shell_events.once('zplug-installed-plugins', () => {
            zshell.stdin.end();
            resolve(true);
        });
    });
    $.verbose = false;
    console.log(`${chalk.bgGreen('[DONE]')} Installed zplug`);
}
export { main };
//# sourceMappingURL=index.js.map