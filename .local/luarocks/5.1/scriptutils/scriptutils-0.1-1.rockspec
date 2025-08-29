package = "restic-utils"
version = "0.1-1"
source = {
  url = "none",
  dir = "."
}
description = {
  summary = "for internal use only",
  detailed = "description",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["scriptutils"] = "scriptutils/init.lua"
  }
}
