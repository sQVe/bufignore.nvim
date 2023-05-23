# 👁️ bufignore

**Bufignore** is a plugin for Neovim that helps you keep your buffer list
organized by **automatically unlisting hidden buffers** that match specific
ignore sources, such as a Lua pattern or Git ignored files. It was designed to
solve the annoyance of a cluttered buffer list when working with Git ignored
files, such as those within `.git` or `node_modules`.

<br />

https://user-images.githubusercontent.com/2284724/232234047-e170007b-7f31-4e6b-b727-ec62a0196710.mp4

<br />

## ✨ Key features

- **Multiple ignore sources**: You can define multiple ignore sources, such as
  Lua patterns and Git ignored files, to filter out hidden buffers that match
  these patterns.
- **Tidy buffer list**: It unlists hidden buffers that match the defined ignore
  sources to keep your buffer list tidy.
- **Efficient event processing**: The plugin efficiently utilizes a queue for
  all events, which feeds batches of buffer events into processing.
- **Supports changing working directory**: Bufignore supports changing the
  current working directory by testing all current buffers, and only unlists
  files that are ignored and within the current working directory.
- **Out-of-the-box usage**: Bufignore works out-of-the-box without requiring any
  configuration tweaking.
- **Customizable**: Bufignore provides a callback function that allows you to
  further configure which buffers should be unlisted based on your needs.
- **Ignores files outside the current working directory**: Bufignore only
  considers files within the current working directory, ignoring files outside
  it.

<br />

## ⚡ Requirements

- [Neovim](https://neovim.io), with the `hidden` option set to `on`.
- [Git](https://git-scm.com).
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).

<br />

## 📦 Installation

#### [lazy](https://github.com/folke/lazy.nvim)

```lua
{
  'sQVe/bufignore.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    -- Input configuration here.
    -- Refer to the configuration section below for options.
  }
},
```

#### [packer](https://github.com/wbthomason/packer.nvim)

```lua
use({
  'sQVe/bufignore.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("bufignore").setup({
      -- Input configuration here.
      -- Refer to the configuration section below for options.
    })
  end
})
```

<br />

## ⚙ Configuration

The following code block shows the available options and their defaults:

```lua
{
  auto_start = true,
  ignore_sources = {
    git = true,
    patterns = { '/%.git/' },
    symlink = true,
  },
  pre_unlist = nil,
}
```

#### `auto_start`

A `boolean` value that determines whether to start the plugin automatically
after calling `setup()`.

#### `ignore_sources`

A `table` that sets which sources to use when checking whether a file is
supposed to be unlisted or not.

###### `git`

A `boolean` value that determines whether Git ignored files are unlisted or not.

###### `patterns`

A `table` of Lua patterns that determines whether the file should be unlisted or
not.

###### `symlink`

A `boolean` value that determines whether symlinked files are unlisted or not.

#### `pre_unlist`

A callback function that executes before unlisting a buffer. You can use this
function to customize which buffers to unlist by returning a `boolean` value.
The unlisting process will only proceed if the callback function returns `true`.

###### Parameters

- `event` (`{ bufnr: number, file_path: string }`) - A table with buffer
  information.

###### Return

Return `true` to proceed with the unlisting process, or anything else to prevent
the buffer from being unlisted.

<br />

## 📗 Usage

Bufignore works out-of-the-box with the `auto_start` option enabled. The
following API is available under `require('bufignore')` if you want to handle
things manually:

#### `setup`

Sets up the plugin, see [configuration](#configuration) for further information.

#### `start`

Start the plugin.

#### `stop`

Stop the plugin.

<br />

## 🤝 Contributing

All contributions to Bufignore are greatly appreciated, whether it's a bug fix
or a feature request. If you would like to contribute, please don't hesitate to
reach out via the
[issue tracker](https://github.com/sQVe/bufignore.nvim/issues).

Before making a pull request, please consider the following:

- Follow the existing code style and formatting conventions .
  - Install [Stylua](https://github.com/johnnymorganz/stylua) to ensure proper
    formatting.
- Write clear and concise commit messages that describe the changes you've made.

<br />

## 🏁 Roadmap

- [x] Performance improvements:
  - [x] Check if current working directory is a Git repository before starting.
  - [x] Avoid processing duplicate file paths.
- [ ] Support for extending ignore lookup beyond Git.
  - [x] Lua patterns.
  - [x] Symlinks.
  - [ ] Filetypes.
  - [ ] Outside the Git repository.
  - [ ] Outside the current working directory.
  - [ ] Custom callback.
- [ ] Allow opting out of unlisting when buffer is either modified or has
      entered insert mode.
- [ ] Provide a single Bufignore command, with sub-commands to execute different
      actions. entered insert mode.
