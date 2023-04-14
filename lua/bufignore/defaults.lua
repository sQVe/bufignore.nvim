--- @alias PreUnlist fun(event: { bufnr: number, file_path: string }): boolean

--- @class UserConfig
--- @field auto_start boolean
--- @field pre_unlist PreUnlist | false | nil TODO
local defaults = {
  auto_start = true,
  pre_unlist = nil,
}

return defaults
