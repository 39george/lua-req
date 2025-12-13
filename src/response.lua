---@class req.Response
local Response = {}
Response.__index = Response

function Response:json()
  local cjson = require("cjson")
  return cjson.decode(self.body)
end

function Response:text() return self.body end
function Response:bytes() return self.body end

return Response
