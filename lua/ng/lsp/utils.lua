local create_tcb_buffer = function(uri, content)
  -- Delete existing buffer
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buffer) == uri then
      vim.cmd.bwipeout(uri)
      break
    end
  end

  -- Create new buffer with content
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, uri)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'typescript', { buf = buf })
  vim.api.nvim_set_option_value('modified', false, { buf = buf })
  return buf
end

local M = {}

--- Jump to the location or open the quickfix list with the possible locations.
--- @param locations lsp.Location[]|lsp.LocationLink[] List of locations.
M.jump_to_location = function(locations)
  if #locations == 0 then
    vim.notify('No location was found!', vim.log.levels.INFO)
  elseif #locations == 1 then
    vim.lsp.util.jump_to_location(locations[1], 'utf-8', true)
  else
    vim.fn.setqflist({}, ' ', {
      title = 'Angular Language Server',
      items = vim.lsp.util.locations_to_items(locations, 'utf-8'),
    })
    vim.api.nvim_command('copen')
  end
end

--- Show the given type check block.
--- @param target 'window'|'tab'|'horizontal'|'vertical' Where the type check block should be shown.
M.show_tcb = function(result, target)
  local uri = tostring(result.uri):gsub('file:///', 'ng:///')
  local content = vim.fn.split(result.content, '\n')
  local buf = create_tcb_buffer(uri, content)

  if target == 'horizontal' then
    vim.cmd.split()
    vim.cmd.buffer(uri)
  elseif target == 'vertical' then
    vim.cmd.vsplit()
    vim.cmd.buffer(uri)
  elseif target == 'tab' then
    vim.cmd.tabnew(uri)
  else
    vim.cmd.edit(uri)
  end

  if result.selections and #result.selections ~= 0 then
    local ns = vim.api.nvim_create_namespace('NG_NVIM')
    vim.api.nvim_set_hl(ns, 'Selection', { standout = true, bold = true })
    vim.api.nvim_win_set_hl_ns(0, ns)

    for _, range in ipairs(result.selections) do
      local start = { range['start'].line, range['start'].character }
      local finish = { range['end'].line, range['end'].character }
      vim.highlight.range(buf, ns, 'Selection', start, finish)
    end

    local firstPos = result.selections[1]['start']
    vim.api.nvim_win_set_cursor(0, { firstPos.line + 1, firstPos.character })
  end
end

return M
