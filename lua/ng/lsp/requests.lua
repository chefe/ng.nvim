--- Special lsp requests for the angular language service.
--- @see [requests.ts on github](https://github.com/angular/vscode-ng-language-service/blob/main/common/requests.ts)
local M = {}

--- Request the template file location for the current cursor location.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param callback lsp.Handler Function to call with the lsp response.
M.get_template_location_for_component = function(bufnr, callback)
  return vim.lsp.buf_request(
    bufnr or 0,
    'angular/getTemplateLocationForComponent',
    vim.lsp.util.make_position_params(bufnr or 0, 'utf-8'),
    callback
  )
end

--- Request the component file locations for the current template file.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param callback lsp.Handler Function to call with the lsp response.
M.get_components_with_template_file = function(bufnr, callback)
  return vim.lsp.buf_request(
    bufnr or 0,
    'angular/getComponentsWithTemplateFile',
    { textDocument = vim.lsp.util.make_text_document_params(bufnr or 0) },
    callback
  )
end

--- Request a template typecheck block for the current cursor location.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param callback lsp.Handler Function to call with the lsp response.
M.get_tcb_under_cursor = function(bufnr, callback)
  return vim.lsp.buf_request(
    bufnr or 0,
    'angular/getTcb',
    vim.lsp.util.make_position_params(bufnr or 0, 'utf-8'),
    callback
  )
end

--- Check if the document is part of an anuglar project.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param callback lsp.Handler Function to call with the lsp response.
M.is_angular_core_in_owning_project = function(bufnr, callback)
  return vim.lsp.buf_request(
    bufnr or 0,
    'angular/isAngularCoreInOwningProject',
    { textDocument = vim.lsp.util.make_text_document_params(bufnr or 0) },
    callback
  )
end

return M
