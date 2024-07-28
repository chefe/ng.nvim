local M = {}

--- Refactor a `.component.ts` file from an inline to an external template.
--- @param buf integer Buffer handle or `0` for current.
M.switch_component_to_external_template = function(buf)
  require('ng.refactor.component_ts.switch_to_external_template')(buf)
end

--- Refactor a `.component.ts` file from an external to an inline template.
--- @param buf integer Buffer handle or `0` for current.
M.switch_component_to_inline_template = function(buf)
  require('ng.refactor.component_ts.switch_to_inline_template')(buf)
end

return M
