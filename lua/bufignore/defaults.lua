--- @class IgnoreSources
--- @field git boolean Whether to unlist a git ignored file or not.
--- @field patterns string[] A table of Lua patterns to determine if the file should be unlisted or not.
--- @field symlink boolean Whether to unlist a symlinks or not.

--- @alias PreUnlist fun(event: { bufnr: number, file_path: string }): boolean

--- @class UserConfig
--- @field auto_start boolean `true` to automatically start the plugin when calling setup, otherwise `false`.
--- @field ignore_sources IgnoreSources A table of ignore sources.
--- @field pre_unlist PreUnlist | false | nil A callback function executed before unlisting a buffer. It allows you to further configure when a buffer should be unlisted by returning a boolean value. If the callback function returns `true`, the buffer will be unlisted.
local defaults = {
  auto_start = true,
  ignore_sources = {
    git = true,
    patterns = { '/%.git/' },
    symlink = true,
  },
  pre_unlist = nil,
}

return defaults
