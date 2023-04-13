local config = require('bufignore.config')
local dispatcher = require('bufignore.dispatcher')

--- @class Init
local M = {}

--- Sets up the plugin.
--- @param overrides? UserConfig Configration which will override the defaults.
M.setup = function(overrides)
  local user_config = config.setup(overrides)

  if user_config.auto_start then
    M.start()
  end
end

--- Starts the plugin.
M.start = function()
  if not vim.o.hidden then
    print("The bufignore plugin requires the 'hidden' option to be enabled.")
    print("Please add 'set hidden' to your Vim configuration.")
    return
  end

  dispatcher.bind_events()
end

--- Stops the plugin.
M.stop = function()
  dispatcher.unbind_events()
end

return M
