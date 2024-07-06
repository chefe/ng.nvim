# ng.nvim

A plugin to bring additional functionality for [Angular][1] to neovim.

## Features

- Go to template for component under cursor
- Go to component(s) for template under cursor

## Usage

```lua
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>at', '<cmd>lua require("ng.lsp").goto_template_of_component(0)<cr>', opts)
vim.keymap.set('n', '<leader>ac', '<cmd>lua require("ng.lsp").goto_components_of_template(0)<cr>', opts)
```

## Credits

- [angular/vscode-ng-language-server][2]
- [joeveiga/ng.nvim][3]

[1]: https://angular.dev
[2]: https://github.com/angular/vscode-ng-language-service
[3]: https://github.com/joeveiga/ng.nvim
