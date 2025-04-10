--- Methods to generate the command to start the angular language server.
local M = {}

--- Check if a file file exists at the given path.
--- @param path string
--- @return boolean
function M.check_exists(path)
  return vim.loop.fs_stat(path) ~= nil
end

--- @class AngularPaths
--- @field bin_path string The path to the language server binary.
--- @field ts_locations string The path to the typescript installation.
--- @field ng_locations string The path to the angular installation.

--- Get the paths for the angular language server command.
--- @param work_dir string
--- @return AngularPaths|nil
function M.get_angular_paths(work_dir)
  -- Check if the language server is installed in the project directory
  local local_bin_path = work_dir .. '/node_modules/.bin/ngserver'
  if M.check_exists(local_bin_path) then
    return {
      bin_path = local_bin_path,
      ts_locations = work_dir,
      ng_locations = work_dir,
    }
  end

  -- Check if the language server installed with mason
  local mason_base = vim.fn.stdpath('data') .. '/mason'
  local mason_path = mason_base .. '/packages/angular-language-server'
  if M.check_exists(mason_path) then
    return {
      bin_path = mason_base .. '/bin/ngserver',
      ts_locations = mason_path,
      ng_locations = mason_path .. '/node_modules/@angular/language-server',
    }
  end

  -- Return `nil` if no language server is found
  return nil
end

--- Get the angular version for the given directory
--- @param work_dir string Path to the project directory
--- @return string|nil
function M.get_angular_core_version(work_dir)
  local file_path = work_dir .. '/node_modules/@angular/core/package.json'
  if not M.check_exists(file_path) then
    return nil
  end

  local package_json = vim.json.decode(io.open(file_path):read('*a'))
  return package_json.version and package_json.version or nil
end

--- Generate the command to start the angular language server.
--- @param work_dir string Path to the current project root.
--- @return string[]|nil command Command or `nil` if the server was not found.
--- @see https://github.com/angular/vscode-ng-language-service/blob/main/server/src/cmdline_utils.ts
function M.get_angular_server_cmd(work_dir)
  local root_dir = vim.fs.root(work_dir, 'angular.json')
  if root_dir ~= nil then
    work_dir = root_dir
  end

  local paths = M.get_angular_paths(work_dir)
  if paths == nil then
    return nil
  end

  local command = {
    paths.bin_path,
    '--stdio',
    '--tsProbeLocations',
    paths.ts_locations,
    '--ngProbeLocations',
    paths.ng_locations,
    '--includeCompletionsWithSnippetText',
    '--includeAutomaticOptionalChainCompletions',
    '--forceStrictTemplates',
  }

  local angular_version = M.get_angular_core_version(work_dir)
  if angular_version ~= nil then
    table.insert(command, '--angularCoreVersion')
    table.insert(command, angular_version)
  end

  return command
end

-- Return the module
return M
