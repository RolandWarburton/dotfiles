package = "restic-utils"
version = "0.1-2"
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
    ["restic-utils"] = "/home/roland/.luarocks/share/lua/restic-utils/init.lua"   -- Full path to the Lua file
  }
}
