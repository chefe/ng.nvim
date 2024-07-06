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

return M
