#!/usr/bin/env node

const program = require('commander')

const { addCompileDB, syncLldbScritpt, setupVSCodeConfig } = require('../build')

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

program
  .command('init')
  .description(
    'setup VScode code Remote Container config, see https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers'
  )
  .action(() => {
    setupVSCodeConfig()
  })

program.parse(process.argv)
