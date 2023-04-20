local config = require('bufignore.config')

--- @class FileProcessor
local M = {}

--- Checks if a buffer meets the requirements for unlisting.
--- @param bufnr number
--- @param file_path string
--- @return boolean `true` if the buffer meets the unlisting requirements, otherwise `false`.
M._is_valid_for_unlisting = function(bufnr, file_path)
  local user_config = config.get_user_config()

  -- Buffer is not visible
  return vim.fn.bufwinid(bufnr) == -1
    -- Buffer is valid
    and vim.api.nvim_buf_is_valid(bufnr)
    -- Buffer is loaded
    and vim.api.nvim_buf_is_loaded(bufnr)
    -- Buffer is listed
    and vim.api.nvim_buf_get_option(bufnr, 'buflisted')
    -- User-defined pre_unlist callback is either falsy or returns true.
    and (
      not user_config.pre_unlist
      or user_config.pre_unlist({ bufnr = bufnr, file_path = file_path })
    )
end

--- Unlists a buffer for an ignored file.
--- @param file_path string
--- @private
M._unlist_ignored_file = function(file_path)
  vim.schedule(function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local bufnr = vim.fn.bufnr(file_path)

    if M._is_valid_for_unlisting(bufnr, file_path) then
      -- Unlist git ignored file buffer.
      vim.api.nvim_buf_set_option(bufnr, 'buflisted', false)
    end
  end)
end

--- Unlists buffers for ignored files.
--- @param file_paths string[]
M.unlist_ignored_files = function(file_paths)
  for _, file_path in ipairs(file_paths) do
    M._unlist_ignored_file(file_path)
  end
end

return M
