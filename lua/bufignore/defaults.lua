--- @alias ConfigCallback fun(event: { bufnr: number, file_path: string }): boolean

--- @class UserConfig
--- @field auto_start boolean
--- @field callback ConfigCallback | false | nil TODO
local defaults = {
  auto_start = true,
  callback = nil,
}

return defaults
