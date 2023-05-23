--- @alias GitCallback fun(ignored_file_paths: string[], exit_code: number): nil

local Job = require('plenary.job')

local config = require('bufignore.config')

--- @class Checker
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
--- @param file_paths string[]
--- @param callback GitCallback
M.get_git_ignored_files = function(file_paths, callback)
  local args = { 'check-ignore' }

  for _, file_path in ipairs(file_paths) do
    table.insert(args, file_path)
  end

  M._execute_git(args, callback)
end

--- Checks if files are ignored by Lua patterns.
--- @param file_paths string[]
M.get_pattern_ignored_files = function(file_paths)
  local user_config = config.get_user_config()

  return vim.tbl_filter(function(file_path)
    for _, pattern in ipairs(user_config.ignore_sources.patterns) do
      if string.match(file_path, pattern) then
        return true
      end
    end

    return false
  end, file_paths)
end

--- Handle files are ignored by Git.
--- @param file_paths string[]
--- @param callback GitCallback
M.handle_git_ignored_files = function(file_paths, callback)
  local args = { 'check-ignore' }

  for _, file_path in ipairs(file_paths) do
    table.insert(args, file_path)
  end

  M._execute_git(args, callback)
end

--- Checks if directory is a Git repository.
--- @param directory string
--- @param callback GitCallback
M.is_git_repository = function(directory, callback)
  M._execute_git({ 'rev-parse', '--show-toplevel' }, callback)
end

return M
