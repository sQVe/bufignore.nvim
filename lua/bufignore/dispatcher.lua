local queue = require('bufignore.queue')

local augroup =
  vim.api.nvim_create_augroup('bufignore-augroup', { clear = true })

--- @class Dispatcher
--- @field private _is_bound boolean
local M = {}

M._is_bound = false

--- Binds event listeners for the plugin.
M.bind_events = function()
  if not M._is_bound then
    -- Listen for `BufHidden` events and enqueue the file for
    -- processing.
    vim.api.nvim_create_autocmd('BufHidden', {
      group = augroup,
      callback = function(event)
        queue.enqueue_file(vim.fn.fnamemodify(event.file, ':p'))
      end,
    })

    -- Listen for `DirChanged` events and enqueue all buffers for
    -- processing.
    vim.api.nvim_create_autocmd('DirChanged', {
      group = augroup,
      callback = function()
        local bufnrs = vim.api.nvim_list_bufs()

        queue.clear_queue()
        for _, bufnr in ipairs(bufnrs) do
          queue.enqueue_file(vim.api.nvim_buf_get_name(bufnr))
        end
      end,
    })

    M._is_bound = true
  end
end

--- Unbinds event listeners for the plugin.
M.unbind_events = function()
  if M._is_bound then
    vim.api.nvim_clear_autocmds({ group = augroup })

    M._is_bound = false
  end
end

return M
