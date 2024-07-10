local M = {}

function M.setup()
  -- Sets the filetype to `angular.html` if it matches the pattern
  vim.filetype.add({
    pattern = {
      ['.*%.component%.html'] = 'angular.html',
    },
  })

  -- Use the `angular` parser for the `angular.html` filetype
  vim.treesitter.language.register('angular', 'angular.html')
end

return M
