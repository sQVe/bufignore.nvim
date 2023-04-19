--- @alias PreUnlist fun(event: { bufnr: number, file_path: string }): boolean

--- @class UserConfig
--- @field auto_start boolean true to automatically start the plugin when calling setup, otherwise false.
--- @field pre_unlist PreUnlist | false | nil A callback function executed before unlisting a buffer. It allows you to further configure when a buffer should be unlisted by returning a boolean value. If the callback function returns `true`, the buffer will be unlisted.
local defaults = {
  auto_start = true,
  pre_unlist = nil,
}

return defaults
