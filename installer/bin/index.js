#!/usr/bin/env node

// require = require('esm')(module /*, options*/);
// require('../dist/cli').cli(process.argv);

import * as cli from '../dist/cli.js';
cli.cli(process.argv);

// const cli = require('../dist/cli');
// cli(process.argv);
