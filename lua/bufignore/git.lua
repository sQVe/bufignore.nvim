local Job = require('plenary.job')

--- @class Git
local M = {}

--- Checks if files are ignored by Git.
--- @param file_paths string[] The list of file paths to check for ignore status.
--- @param callback function The callback function that receives the ignored file paths.
M.check_ignore = function(file_paths, callback)
  local args = { 'check-ignore' }

  for _, file_path in ipairs(file_paths) do
    table.insert(args, file_path)
  end

  -- Execute the Git command.
  Job:new({
    command = 'git',
    args = args,
    on_exit = function(_, exit_code)
      if exit_code > 0 then
        callback({})
      end
    end,
    on_stdout = function(_, data)
      local ignored_file_paths = {}
      for line in data:gmatch('([^\n]+)') do
        table.insert(ignored_file_paths, line)
      end

      callback(ignored_file_paths)
    end,
  }):start()
end

return M
