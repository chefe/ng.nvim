local utils = require('ng.refactor.component_ts.utils')

local component_ts_template_url = [[
(decorator
  (call_expression
    function: ((identifier) @_name
      (#eq? @_name "Component"))
    arguments: (arguments
      (object
        (pair
          key: ((property_identifier) @_property
            (#eq? @_property "templateUrl"))
          value: (string
            (string_fragment) @url))))))
]]

local build_inline_template_lines = function(template_content)
  local lines = {}

  table.insert(lines, '  template: `')

  for _, v in ipairs(template_content) do
    table.insert(lines, '    ' .. v)
  end

  table.insert(lines, '  `,')

  return lines
end

local resolve_relative_path_to_buffer = function(bufnr, path)
  local base_path = vim.api.nvim_buf_get_name(bufnr)
  local base_dir = vim.fn.fnamemodify(base_path, ':h')
  return vim.fn.fnamemodify(base_dir .. '/' .. path, ':p')
end

local switch_component_to_inline_template = function(buf)
  if not utils.is_component_ts_file(buf) then
    return
  end

  local ts_file_buffer = buf ~= 0 and buf or vim.api.nvim_win_get_buf(0)

  local url_node = utils.get_ts_node_by_capture_name(
    ts_file_buffer,
    component_ts_template_url,
    'url'
  )
  if url_node == nil then
    return
  end

  local html_file_path = resolve_relative_path_to_buffer(
    ts_file_buffer,
    vim.treesitter.get_node_text(url_node, ts_file_buffer)
  )
  if html_file_path == nil then
    return
  end

  vim.cmd.edit(html_file_path)

  local html_file_buffer = vim.api.nvim_get_current_buf()
  local html_file_content =
    vim.api.nvim_buf_get_text(html_file_buffer, 0, 0, -1, -1, {})

  vim.cmd.buffer(ts_file_buffer)

  local start_row, _, end_row, _ = url_node:parent():parent():range(false)

  vim.api.nvim_buf_set_lines(
    buf,
    start_row,
    end_row + 1,
    true,
    build_inline_template_lines(html_file_content)
  )
  vim.cmd.write()

  vim.cmd.bdelete(html_file_buffer)
  vim.fn.delete(html_file_path)
end

return switch_component_to_inline_template
