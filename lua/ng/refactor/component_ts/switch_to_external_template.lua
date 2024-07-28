local utils = require('ng.refactor.component_ts.utils')

local query_component_ts_template_content = [[
(decorator
  (call_expression
    function: ((identifier) @_name
      (#eq? @_name "Component"))
    arguments: (arguments
      (object
        (pair
          key: ((property_identifier) @_property
            (#eq? @_property "template"))
          value: (template_string
            (string_fragment) @content))))))
]]

local split_into_lines = function(value)
  local lines = {}

  for s in value:gmatch('[^\n]+') do
    table.insert(lines, s)
  end

  return lines
end

local switch_component_to_external_template = function(buf)
  if not utils.is_component_ts_file(buf) then
    return
  end

  local ts_file_buffer = buf ~= 0 and buf or vim.api.nvim_win_get_buf(0)
  local ts_file_path = vim.api.nvim_buf_get_name(ts_file_buffer)
  local html_file_path = ts_file_path:gsub('.ts$', '.html')

  local content_node = utils.get_ts_node_by_capture_name(
    ts_file_buffer,
    query_component_ts_template_content,
    'content'
  )
  if content_node == nil then
    return
  end

  local content = vim.treesitter.get_node_text(content_node, ts_file_buffer)

  vim.cmd.edit(html_file_path)

  local html_file_buffer = vim.api.nvim_get_current_buf()
  local lines = split_into_lines(content)

  vim.api.nvim_buf_set_text(html_file_buffer, 0, 0, -1, -1, lines)
  vim.cmd.write()

  vim.cmd.buffer(ts_file_buffer)

  local start_row, _, end_row, _ = content_node:parent():parent():range(false)

  local html_file_name = vim.fn.fnamemodify(html_file_path, ':t')
  local line = "  templateUrl: './" .. html_file_name .. "',"

  vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, true, { line })
end

return switch_component_to_external_template
