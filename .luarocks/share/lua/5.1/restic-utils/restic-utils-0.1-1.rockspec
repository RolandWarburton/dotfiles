package = "restic-utils"
version = "0.1-1"
source = {
  url = "none", -- Local installation, no URL source
  dir = "."
}
description = {
  summary = "Restic utilities for running backups",
  detailed = [[
  Collection of helper scripts to bootstrap and run restic backups with S3
   ]],
  license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["restic-utils"] = "/home/roland/.local/luarocks/5.1/restic-utils/restic-utils.lua"   -- Full path to the Lua file
  }
}
