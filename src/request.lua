local Response = require "req.response"
local cjson = require "cjson"
local http_request = require "http.request"
local util = require "req.util"

---@class req.Request
local Request = {}
Request.__index = Request

function Request:header(k, v)
  self.headers[k] = v
  return self
end

function Request:json(tbl)
  self.opts.json = tbl
  self.headers["content-type"] = self.headers["content-type"]
    or "application/json"
  return self
end

function Request:timeout(ms)
  self.opts.timeout = ms
  return self
end

function Request:send()
  local url = util.with_query(self.url, self.query)
  local body = self.body
  if self.opts.json ~= nil then
    body = cjson.encode(self.opts.json)
    self.headers["content-type"] = self.headers["content-type"]
      or "application/json"
  end
  local req = http_request.new_from_uri(url)
  req.headers:upsert(":method", self.method)

  for name, hv in pairs(self.headers or {}) do
    local v = hv
    if type(v) == "function" then v = v() end
    if type(v) == "table" then
      for _, one in ipairs(v) do
        req.headers:append(name, tostring(one))
      end
    elseif v ~= nil then
      req.headers:upsert(name, tostring(v))
    end
  end

  if body ~= nil then req:set_body(body) end

  local res_headers, stream = assert(req:go(self.opts.timeout))
  local res_body = assert(stream:get_body_as_string())

  local out = {}
  for k, v in res_headers:each() do
    if out[k] == nil then
      out[k] = v
    else
      out[k] = tostring(out[k]) .. ", " .. v
    end
  end

  local status = tonumber(res_headers:get(":status")) or 0

  return setmetatable({
    status = status,
    headers = out,
    body = res_body,
  }, Response)
end

function Request:send_safe()
  return pcall(function() return self:send() end)
end

return Request
