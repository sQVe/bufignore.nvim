local git = require('bufignore.git')
local queue = require('bufignore.queue')

local augroups = {}
local events = { 'BufHidden', 'DirChanged' }

for _, event_type in ipairs(events) do
  table.insert(
    augroups,
    vim.api.nvim_create_augroup('bufignore-' .. event_type, { clear = true })
  )
end

--- @class Dispatcher
--- @field private _is_buf_hidden_bound boolean
--- @field private _is_dir_changed_bound boolean
--- @field private _is_git_repository boolean | nil
local M = {}

M._is_buf_hidden_bound = false
M._is_dir_changed_bound = false
M._is_git_repository = nil

--- Bind BufHidden event, if it isn't bound.
--- @private
M._bind_buf_hidden_event = function()
  if not M._is_buf_hidden_bound then
    -- On `BufHidden` event: enqueue the file for
    -- processing.
    vim.api.nvim_create_autocmd('BufHidden', {
      group = augroups.BufHidden,
      callback = function(event)
        queue.enqueue_file(event.file)
      end,
    })

    M._is_buf_hidden_bound = true
  end
end

--- Bind DirChanged event, if it isn't bound.
--- @private
M._bind_dir_changed_event = function()
  if not M._is_dir_changed_bound then
    -- On `DirChanged` event: rerun event binding.
    vim.api.nvim_create_autocmd('DirChanged', {
      group = augroups.DirChanged,
      callback = function()
        M._is_git_repository = nil
        M._unbind_buf_hidden_event()
        queue.clear_queue()
        M.bind_events()
      end,
    })

    M._is_dir_changed_bound = true
  end
end

--- Unbind BufHidden event, if it is bound.
--- @private
M._unbind_buf_hidden_event = function()
  if M._is_buf_hidden_bound then
    vim.api.nvim_clear_autocmds({ group = augroups.BufHidden })
    M._is_buf_hidden_bound = false
  end
end

--- Unbind DirChanged event, if it is bound.
--- @private
M._unbind_dir_changed_event = function()
  if M._is_dir_changed_bound then
    vim.api.nvim_clear_autocmds({ group = augroups.DirChanged })
    M._is_dir_changed_bound = false
  end
end

-- Binds event listeners for the plugin.
M.bind_events = function()
  vim.schedule(function()
    if M._is_git_repository == nil then
      git.is_git_repository(vim.fn.getcwd(), function(_, exit_code)
        M._is_git_repository = exit_code == 0
        M.bind_events()
      end)
    end

    M._bind_dir_changed_event()
    if M._is_git_repository then
      queue.enqueue_current_buffer_list()
      M._bind_buf_hidden_event()
    else
      M._unbind_buf_hidden_event()
    end
  end)
end

--- Unbinds all event listeners for the plugin.
M.unbind_events = function()
  M._unbind_buf_hidden_event()
  M._unbind_dir_changed_event()
end

return M
