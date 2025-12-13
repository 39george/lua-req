local Request = require "req.request"
local util = require "req.util"

---@class req.Client
local Client = {}
local Client_mt = {
  __index = Client,
  __metatable = "protected",
  __newindex = function(_, k, _) error("readonly: " .. tostring(k), 2) end,
}

function Client.new(opts) return setmetatable({ opts = opts or {} }, Client_mt) end

function Client:request(method, url, opts)
  local req_opts = util.merge(self.opts, opts or {})
  return setmetatable({
    client = self,
    method = method,
    url = url,
    opts = req_opts,
    headers = util.merge(req_opts.headers or {}, {}),
    query = util.merge(req_opts.query or {}, {}),
    body = req_opts.body,
  }, Request)
end

function Client:get(url, opts) return self:request("GET", url, opts) end
function Client:put(url, opts) return self:request("PUT", url, opts) end
function Client:patch(url, opts) return self:request("PATCH", url, opts) end
function Client:delete(url, opts) return self:request("DELETE", url, opts) end
function Client:head(url, opts) return self:request("HEAD", url, opts) end
function Client:options(url, opts) return self:request("OPTIONS", url, opts) end

return Client
