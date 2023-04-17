local git = require('bufignore.git')
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
--- @param file_path string The file path to validate.
--- @return boolean is_valid_file_path `true` if the file path is valid, otherwise `false`.
--- @private
M._is_valid_file = function(file_path)
  local is_non_empty_file_path = file_path ~= nil and file_path:len() > 0
  local is_file_path_in_cwd = vim.startswith(file_path, vim.fn.getcwd())

  return is_non_empty_file_path and is_file_path_in_cwd
end

--- Clears the event queue.
M.clear_queue = function()
  M._queue = {}
  M._is_running = false
end

--- Adds an event to the queue, and starts processing if not already running.
--- @param file_path string
M.enqueue_file = function(file_path)
  if not M._is_file_in_queue(file_path) and M._is_valid_file(file_path) then
    local absolute_file_path = vim.fn.fnamemodify(file_path, ':p')

    table.insert(M._queue, absolute_file_path)

    M._process_queue()
  end
end

--- Processes pending file paths in the queue after the throttle time, if not already running.
--- @private
M._process_queue = function()
  if M._is_running then
    return
  end

  M._is_running = true

  vim.defer_fn(function()
    local pending_files = vim.deepcopy(M._queue)

    git.check_ignore(pending_files, file_processor.unlist_ignored_files)

    M.clear_queue()
  end, M._throttle_ms)
end

return M
