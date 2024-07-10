# ng.nvim

A plugin to bring additional functionality for [Angular][1] to neovim.

## Features

- Go to template for component under cursor
- Go to component(s) for template under cursor
- Display template type check block
- Check if a file is part of an angular project
- Setup [tree sitter grammer for angular][2]

## Installation

[Lazy][3]:

```lua
return {
  {
    'chefe/ng.nvim',
    dependencies = { 'dlvandenberg/tree-sitter-angular' },
    config = function()
      require('ng').setup()
    end,
  },
}
```

## Usage

```lua
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>at', '<cmd>lua require("ng.lsp").goto_template_of_component(0)<cr>', opts)
vim.keymap.set('n', '<leader>ac', '<cmd>lua require("ng.lsp").goto_components_of_template(0)<cr>', opts)
vim.keymap.set('v', '<leader>ab', '<cmd>lua require("ng.lsp").show_template_tcb(0, "window")<cr>', opts)
vim.keymap.set('v', '<leader>abt', '<cmd>lua require("ng.lsp").show_template_tcb(0, "tab")<cr>', opts)
vim.keymap.set('v', '<leader>abv', '<cmd>lua require("ng.lsp").show_template_tcb(0, "vertical")<cr>', opts)
vim.keymap.set('v', '<leader>abh', '<cmd>lua require("ng.lsp").show_template_tcb(0, "horizontal")<cr>', opts)

require('ng.lsp').is_in_angular_project(0, function (result)
  if result then
    vim.print('Angular project detected')
  else
    vim.print('No angular project detected')
  end
end)
```

## Credits

- [angular/vscode-ng-language-server][4]
- [joeveiga/ng.nvim][5]

[1]: https://angular.dev
[2]: https://github.com/dlvandenberg/tree-sitter-angular
[3]: https://lazy.folke.io
[4]: https://github.com/angular/vscode-ng-language-service
[5]: https://github.com/joeveiga/ng.nvim
