---@class req.Response
local Response = {}
Response.__index = Response

function Response:json()
  if type(self.body) ~= "string" then return false, "body is not a string" end
  local cjson = require("cjson")
  local ok, val = pcall(cjson.decode, self.body)
  if not ok then return false, val end
  return true, val
end
function Response:text() return self.body end
function Response:bytes() return self.body end

function Response:header(name)
  if not self.headers or not name then return nil end

  local v = self.headers[name]
  if v ~= nil then return v end

  local low = tostring(name):lower()
  v = self.headers[low]
  if v ~= nil then return v end

  for k, vv in pairs(self.headers) do
    if type(k) == "string" and k:lower() == low then return vv end
  end
  return nil
end

function Response:content_type()
  local ct = self:header("content-type")
  if not ct then return nil end
  return (tostring(ct):match("^%s*([^;]+)")) or ct
end

function Response:raise_for_status()
  local s = tonumber(self.status) or 0
  if s >= 400 then
    local preview = ""
    if type(self.body) == "string" and #self.body > 0 then
      preview = self.body:sub(1, 200):gsub("%s+", " ")
    end
    error(
      ("HTTP error %d%s"):format(s, preview ~= "" and (": " .. preview) or ""),
      2
    )
  end
  return self
end

function Response:validate(fn)
  local ok, v, err = pcall(fn, self)
  if not ok then return false, v end
  if v == nil or v == false then return false, err or "validation failed" end
  return true, v
end

return Response
