local requests = require('ng.lsp.requests')
local server = require('ng.lsp.server')
local utils = require('ng.lsp.utils')

local M = {}

--- Go to template of the component under the cursor.
--- @param bufnr integer Buffer handle or 0 for current.
M.goto_template_of_component = function(bufnr)
  requests.get_template_location_for_component(bufnr or 0, function(_, result)
    if result then
      utils.jump_to_location({ result })
    end
  end)
end

--- Find the components for a template under the cursor.
--- @param bufnr integer Buffer handle or 0 for current.
M.goto_components_of_template = function(bufnr)
  requests.get_components_with_template_file(bufnr or 0, function(_, result)
    if result then
      utils.jump_to_location(result)
    end
  end)
end

--- Displays a type check block for the current selection in the template.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param target 'window'|'tab'|'horizontal'|'vertical' Where the type check block should be shown.
---   'window'     - Open tcb in the current window. (default)
---   'tab'        - Open tcb in a new tab.
---   'horizontal' - Open tcb in a horizontal split.
---   'vertical'   - Open tcb in a vertical split.
M.show_template_tcb = function(bufnr, target)
  requests.get_tcb_under_cursor(bufnr, function(_, result)
    if result then
      utils.show_tcb(result, target)
    end
  end)
end

--- Check if the file of the provided buffer is part of an angular project.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param callback function This callback is called with `true` or `false`.
M.is_in_angular_project = function(bufnr, callback)
  requests.is_angular_core_in_owning_project(bufnr, function(_, result)
    callback(result and result == true)
  end)
end

--- Generate the command to start the angular language server.
--- @param work_dir string Path to the current project root.
--- @return string[]|nil command Command or `nil` if the server was not found.
M.get_angular_server_cmd = function(workdir)
  return server.get_angular_server_cmd(workdir)
end

return M
