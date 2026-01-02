# nvim-fountain

A modern Neovim plugin for the [Fountain](https://fountain.io/) screenplay markup language, forked from Carson Fire's [vim-fountain](http://www.vim.org/scripts/script.php?script_id=3880).
> [!WARNING]
> Breaking changes may occur due to a username change from `00msjr` to `0mykull`.
> Update your config to `0mykull/nvim-fountain`.

> This warning message will be removed with the next version update.

## Features

- Syntax highlighting for Fountain screenplay format
- Navigation between scene headings
- Keyboard shortcuts for common screenwriting tasks
- Screenplay statistics (scene count, character appearances, etc.)
- Export to PDF, HTML, and Final Draft formats
- Compatible with Neovim and LazyVim

## About Fountain

Fountain is a plain text markup language for screenwriting. The format can be converted into Final Draft files (FDX) and HTML, and can be imported by Final Draft and Movie Magic.

The official [Fountain website](https://fountain.io/) contains helpful material, including sample scripts and apps.

Here is an excerpt from Big Fish by John August, one of the screenwriters behind Fountain:

```
EDWARD
(whispering)
Turn off your flashlights!  She'll see 'em.

MOVING UP behind the kids, we find ourselves at the gates of...

EXT.  A CREEPY OLD HOUSE - NIGHT

ADULT EDWARD (V.O.)
Now, it's common knowledge that most towns of a certain size have a witch, if only to eat misbehaving children and the occasional puppy who wanders into her yard.  Witches use those bones to cast spells and curses that make the land infertile.
```

## Installation

### Using [LazyVim](https://github.com/LazyVim/LazyVim) / [lazy.nvim](https://github.com/folke/lazy.nvim)

Add to your LazyVim config (e.g., in `lua/plugins/fountain.lua`):

```lua
return {
  "0mykull/nvim-fountain",
  ft = "fountain",  -- Lazy-load only for fountain files
  config = function()
    require("nvim-fountain").setup({
      -- Optional configuration
      keymaps = {
        next_scene = "]]",
        prev_scene = "[[",
        uppercase_line = "<S-CR>",
      },
      -- Export configuration
      export = {
        pdf = { options = "--overwrite" },
      },
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "0mykull/nvim-fountain",
  ft = "fountain",  -- Lazy-load only for fountain files
  config = function()
    require("nvim-fountain").setup({
      -- Optional configuration
    })
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
" In your init.vim
Plug '0mykull/nvim-fountain', {'for': 'fountain'}

" After plug#end(), add:
augroup fountain_setup
  autocmd!
  autocmd FileType fountain lua require('nvim-fountain').setup()
augroup END
```

### Using built-in Neovim package manager

```bash
# Clone the repository
mkdir -p ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/0mykull/nvim-fountain.git ~/.local/share/nvim/site/pack/plugins/start/nvim-fountain
```

Then in your init.lua:

```lua
-- Initialize the plugin
require('nvim-fountain').setup()
```

## Configuration

You can customize the plugin by passing options to the setup function. See the [examples directory](./examples/) for complete configuration examples.

```lua
require("nvim-fountain").setup({
  -- Keyboard mappings
  keymaps = {
    next_scene = "]]",
    prev_scene = "[[",
    uppercase_line = "<S-CR>",
  },

  -- Export settings
  export = {
    -- Default export directory (nil means same as source file)
    output_dir = nil,

    -- PDF export options
    pdf = {
      options = "--overwrite",
    },
  },

  -- Enable treesitter integration if available
  use_treesitter = true,
})
```

## Commands

### Editing and Navigation

- `:FountainStats` - Display screenplay statistics (scene count, character appearances, etc.)
- `:FountainFormat` - Format the current fountain document

### Export

- `:FountainExportPDF [filename]` - Export to PDF (optional filename)

## Default Keymaps

- `]]` - Navigate to next scene heading
- `[[` - Navigate to previous scene heading
- `<S-CR>` - Make current line uppercase and move to next line

## Screenplay Statistics

The `:FountainStats` command provides useful information about your screenplay:

- Total number of scenes
- List of characters with number of appearances
- Dialogue and action line counts
- Total line count

This can help track your screenplay's structure and character balance.

## Export

The export functionality requires [afterwriting](https://github.com/ifrost/afterwriting-labs/blob/master/docs/clients.md) to be installed:

```bash
npm install -g afterwriting
```

Once installed, you can use the export commands to convert your Fountain screenplay to PDF:

- PDF: `:FountainExportPDF [optional-filename.pdf]`

## Example Files

The plugin includes example files to help you get started:

- `examples/template.fountain`: A sample screenplay demonstrating Fountain syntax
- `examples/lazyvim_config.lua`: Configuration example for LazyVim users
- `examples/standalone_config.lua`: Configuration example for direct use with any Neovim setup

To use the template:

```bash
cp examples/template.fountain ~/my-screenplay.fountain
nvim ~/my-screenplay.fountain
```

## Contributing

Contributions are welcome! See the [examples/COMMIT_MESSAGE.md](./examples/COMMIT_MESSAGE.md) file for a summary of the changes made to modernize this plugin.
