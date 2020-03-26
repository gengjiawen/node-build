import * as fs from 'fs-extra'
import * as path from 'path'
import * as os from 'os'

export function addCompileDB() {
  const configPath = path.join(process.cwd(), '.vscode/c_cpp_properties.json')
  if (!fs.existsSync(configPath)) {
    throw new Error(
      `${configPath} not exists, You need to generate vscode c++ config first, see https://code.visualstudio.com/docs/cpp/cpp-ide`
    )
  }

  const json = require(configPath)
  json.configurations[0].compileCommands =
    '${workspaceFolder}/Debug/compile_commands.json'

  // I wish pretty json output is default :(
  fs.writeFileSync(configPath, JSON.stringify(json, null, 2))
}

export function syncLldbScritpt() {
  const v8_files = path.join(__dirname, '..', 'v8-files')
  fs.copySync(v8_files, os.homedir(), {
    overwrite: false,
    errorOnExist: true,
  })
}
