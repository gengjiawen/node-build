#!/usr/bin/env node

const program = require('commander')

const { addCompileDB, syncLldbScritpt } = require('../build')

program
  .version(require('../package.json').version)
  .command('addcc')
  .description('add vscode compile commands to config')
  .action(() => {
    addCompileDB()
  })

program
  .command('setuplldb')
  .description('copy v8 lldb script to your homedir')
  .action(() => {
    syncLldbScritpt()
  })

program.parse(process.argv)
