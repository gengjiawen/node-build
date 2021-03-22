#!/usr/bin/env node

const program = require('commander')

const {
  addCompileDB,
  syncLldbScritpt,
  setupVSCodeConfig,
  patchV8,
} = require('../build')

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

program
  .command('patch-v8')
  .description('patch v8 in CMakeLists.txt')
  .action(() => {
    patchV8()
  })

program.parse(process.argv)
