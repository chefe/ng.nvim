local requests = require('ng.lsp.requests')
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

return M
