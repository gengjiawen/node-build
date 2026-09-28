import * as fs from 'fs-extra'
import * as path from 'path'
import * as os from 'os'
import { execFileSync } from 'child_process'

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

export function setupVSCodeConfig() {
  const v8_files = path.join(__dirname, '..', 'template', '.devcontainer')
  const dest = path.join(process.cwd(), '.devcontainer')
  fs.copySync(v8_files, dest, {
    overwrite: false,
    errorOnExist: true,
  })
}

export function patchV8() {
  // https://regex101.com/r/42r0wp/1
  const regex = /set\(TARGET "v8"\)(.*?)unset\(TARGET\)/gms
  const cmake_path = path.join(process.cwd(), 'CMakeLists.txt')
  const node_cmake = fs.readFileSync(cmake_path).toString()

  // The substituted value will be contained in the result variable
  const result = node_cmake.replace(regex, ``)
  fs.writeFileSync(cmake_path, result)
}

export function generateCMake() {
  const nodeDir = process.cwd()
  if (!fs.existsSync(path.join(nodeDir, 'tools', 'gyp_node.py'))) {
    throw new Error(
      `${nodeDir} is not a Node.js source root (tools/gyp_node.py not found)`
    )
  }

  execFileSync('./configure', { stdio: 'inherit' })

  // Same gyp flags ./configure uses, but with the cmake generator
  const python = execFileSync('python3', [
    '-c',
    'import sys; print(sys.executable)',
  ])
    .toString()
    .trim()
  execFileSync(
    python,
    [
      'tools/gyp_node.py',
      '--no-parallel',
      '-Dconfiguring_node=1',
      '-Dbuild_type=Release',
      `-Dpython=${python}`,
      '-f',
      'cmake',
    ],
    { stdio: 'inherit' }
  )
}
