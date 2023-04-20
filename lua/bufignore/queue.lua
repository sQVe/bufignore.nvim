local checker = require('bufignore.checker')
local config = require('bufignore.config')
local file_processor = require('bufignore.file-processor')

--- @class Queue
--- @field private _queue string[]
--- @field private _is_running boolean
--- @field private _throttle_ms number
local M = {}

M._is_running = false
M._queue = {}
M._throttle_ms = 400

--- Checks if file is already enqueued for processing.
--- @param file_path string The file path to check.
--- @return boolean is_file_in_queue `true` if the file path is valid, otherwise `false`.
--- @private
M._is_file_in_queue = function(file_path)
  return vim.tbl_contains(M._queue, file_path)
end

--- Validates a file.
--- @param relative_file_path string The relative file path to validate.
--- @param absolute_file_path string The absolute file path to validate.
--- @return boolean is_valid_file_path `true` if the file path is valid, otherwise `false`.
--- @private
M._is_valid_file = function(relative_file_path, absolute_file_path)
  local is_non_empty_file_path = relative_file_path ~= nil
    and relative_file_path:len() > 0

  local is_file_path_in_cwd = false
  if is_non_empty_file_path then
    is_file_path_in_cwd = vim.startswith(absolute_file_path, vim.fn.getcwd())
  end

  return is_non_empty_file_path and is_file_path_in_cwd
end

--- Processes pending file paths in the queue after the throttle time, if not already running.
--- @private
M._process_queue = function()
  if M._is_running then
    return
  end

  M._is_running = true

  vim.defer_fn(function()
    local user_config = config.get_user_config()
    local pending_files = vim.deepcopy(M._queue)

    if vim.tbl_count(user_config.ignore_sources.patterns) > 0 then
      local pattern_ignored_files =
        checker.get_pattern_ignored_files(pending_files)

      if vim.tbl_count(pattern_ignored_files) > 0 then
        file_processor.unlist_ignored_files(pattern_ignored_files)

        -- Remove any file that is already ignored via a pattern.
        pending_files = vim.tbl_filter(function(pending_file)
          return not vim.tbl_contains(pattern_ignored_files, pending_file)
        end, pending_files)
      end
    end

    if user_config.ignore_sources.git then
      checker.get_git_ignored_files(
        pending_files,
        file_processor.unlist_ignored_files
      )
    end

    M.clear_queue()
  end, M._throttle_ms)
end

--- Clears the event queue.
M.clear_queue = function()
  M._queue = {}
  M._is_running = false
end

--- Adds an event to the queue, and starts processing if not already running.
--- @param relative_file_path string
M.enqueue_file = function(relative_file_path)
  local absolute_file_path = vim.fn.fnamemodify(relative_file_path, ':p')

  if
    not M._is_file_in_queue(absolute_file_path)
    and M._is_valid_file(relative_file_path, absolute_file_path)
  then
    table.insert(M._queue, absolute_file_path)

    M._process_queue()
  end
end

--- Enqueus all current buffers in list for processing.
M.enqueue_current_buffer_list = function()
  local bufnrs = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(bufnrs) do
    M.enqueue_file(vim.api.nvim_buf_get_name(bufnr))
  end
end

return M
