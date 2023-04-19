local defaults = require('bufignore.defaults')

--- @class Config
--- @field private _user_config UserConfig
local M = {}

M._user_config = nil

--- Gets the user's configuration.
--- @return UserConfig config
M.get_user_config = function()
  return M._user_config
end

--- Sets up the configuration.
--- @param overrides? UserConfig Overrides that will be merged with the defaults.
--- @return UserConfig config
M.setup = function(overrides)
  M._user_config = vim.tbl_deep_extend('force', defaults, overrides or {})

  return M._user_config
end

return M
