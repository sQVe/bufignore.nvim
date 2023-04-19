# 👁️ bufignore

**Bufignore** is a plugin for [Neovim](https://neovim.io) that helps you keep
your buffer list **tidy** by unlisting hidden buffers that are Git ignored. It
was created to solve the annoyance of a cluttered buffer list when working with
Git ignored files, for example, files within `node_modules`.

<br />

https://user-images.githubusercontent.com/2284724/232234047-e170007b-7f31-4e6b-b727-ec62a0196710.mp4

<br />

## ✨ Features

- Only targets hidden buffers, i.e., not visible in any window.
- Efficiently utilizes a queue for all events, which feeds batches of buffer
  events into processing.
- Supports changing the current working directory by testing all current
  buffers.
- Works out-of-the-box without requiring any configuration tweaking.
- Provides a callback to allow you to further configure when a buffer should be
  unlisted.
- Ignores files outside the current working directory.

<br />

## ⚡ Requirements

- [Neovim](https://neovim.io), with the `hidden` option set to `on`.
- [Git](https://git-scm.com).

<br />

## 📦 Installation

#### [lazy](https://github.com/folke/lazy.nvim)

```lua
{
  'sQVe/bufignore.nvim',
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
  pre_unlist = nil,
}
```

#### `auto_start`

A `boolean` value that determines whether to start the plugin automatically
after calling `setup()`.

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

### `setup`

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

- [ ] Performance improvements:
  - [ ] Check if current working directory is a Git repository before starting.
  - [x] Avoid processing duplicate file paths.
- [ ] Provide a single Bufignore command, with sub-commands to execute different
      actions.
- [ ] Optional: Unlist files that are outside of the Git repository.
- [ ] Optional: Support for extending ignore lookup beyond Git, such as, using
      Lua patterns.
- [ ] Optional: Allow opting out of unlisting when buffer is either modified or
      has been in insert mode.
