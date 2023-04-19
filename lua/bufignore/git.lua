--- @alias GitCallback fun(ignored_file_paths: string[], exit_code: number): nil

local Job = require('plenary.job')

--- @class Git
local M = {}

--- @param args string[]
--- @param callback fun(lines: string[], exit_code: number)
M._execute_git = function(args, callback)
  local lines = {}

  -- Execute the Git command.
  Job:new({
    command = 'git',
    args = args,
    on_exit = function(_, exit_code)
      callback(lines, exit_code)
    end,
    on_stdout = function(_, data)
      for line in data:gmatch('([^\n]+)') do
        table.insert(lines, line)
      end
    end,
  }):start()
end

--- Checks if files are ignored by Git.
--- @param file_paths string[] The list of file paths to check for ignore status.
--- @param callback GitCallback The callback function that receives the ignore information.
M.check_ignore = function(file_paths, callback)
  local args = { 'check-ignore' }

  for _, file_path in ipairs(file_paths) do
    table.insert(args, file_path)
  end

  M._execute_git(args, callback)
end

--- Checks if directory is a Git repository.
--- @param directory string The directory path to check.
--- @param callback GitCallback directory path to check.
M.is_git_repository = function(directory, callback)
  M._execute_git({ 'rev-parse', '--show-toplevel' }, callback)
end

return M
