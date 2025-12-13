rockspec_format = "3.1"
package = "lua-req"
version = "dev-1"
source = {
  url = "...",
}
description = {
  summary = "Convenient http client for lua",
  detailed = [[
    This package built with cqueues & http in async manner.
  ]],
  homepage = "...",
  license = "MIT",
}
dependencies = {
  "lua >= 5.4",
  "cqueues >= 20200726.54-0",
  "http >= 0.4.0",
  "lua-cjson >= 2.1.0.10-1",
}
build = {
  type = "builtin",
  modules = {
    req = "src/init.lua",
    ["req.client"] = "src/client.lua",
    ["req.request"] = "src/request.lua",
    ["req.response"] = "src/response.lua",
    ["req.util"] = "src/util.lua",
    -- ["req._meta"] = "types/req.meta.lua",
  },
}
test = {
  type = "command",
  command = "busted spec/",
}
