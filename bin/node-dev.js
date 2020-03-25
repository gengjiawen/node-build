#!/usr/bin/env node

const program = require('commander')

const { addCompileDB } = require('../build')

program
  .version(require('../package.json').version)
  .command('configcpp')
  .action(() => {
    addCompileDB()
  })

program.parse(process.argv)
