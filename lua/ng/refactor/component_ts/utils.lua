local M = {}

--- Get the treesitter node in the query for the capture with the given name.
--- @param bufnr integer Buffer handle or 0 for current.
--- @param query string Query with capture definition.
--- @param name string Name of the capture which should be returned.
--- @return TSNode|nil
function M.get_ts_node_by_capture_name(bufnr, query, name)
  local trees = vim.treesitter.get_parser(bufnr):parse()
  if #trees == 0 then
    return nil
  end

  local treesitter_query = vim.treesitter.query.parse('typescript', query)
  for id, node in treesitter_query:iter_captures(trees[1]:root(), bufnr) do
    if treesitter_query.captures[id] == name then
      return node
    end
  end

  return nil
end

--- Check if the given buffer is an Angular `component.ts` file.
--- @param bufnr integer Buffer handle or `0` for current.
--- @return boolean
function M.is_component_ts_file(bufnr)
  local buf = bufnr or 0

  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
  if filetype ~= 'typescript' then
    return false
  end

  local path = vim.api.nvim_buf_get_name(buf)
  return path:match('^(.*).component.ts$') ~= nil
end

return M
