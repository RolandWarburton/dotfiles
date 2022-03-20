import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import { main } from './index.js';
export async function cli(processArgs) {
    const args = yargs(hideBin(processArgs))
        .strict() // reject garbage args
        .option('config', {
        describe: 'Path to the configuration file',
        type: 'string',
        default: '../config.json'
    })
        .option('dotbotConfig', {
        describe: 'Path to the dotbot configuration file',
        type: 'string',
        default: '../install.conf.yaml'
    })
        .option('packages', {
        describe: 'Path to the packages.yaml',
        type: 'string',
        default: '../src/packages.yaml'
    });
    const argv = await args.argv;
    console.log(argv);
    let config = {
        packages: argv.packages,
        dotbotConfig: argv.dotbotConfig
    };
    await main(config);
}
//# sourceMappingURL=cli.js.map