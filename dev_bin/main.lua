local cqueues = require "cqueues"
local inspect = require "inspect"

local client = require "src.client".new()
local cq = cqueues.new()

cq:wrap(function()
  local resp = client
    :request("POST", "https://nile.trongrid.io/wallet/getnowblock")
    :send()
    :json()
  print("Request 1 done: " .. inspect(resp))
end)

cq:wrap(function()
  local ok, res = client
    :request("POST", "https://nile.trongrid.io/wallet/getnowblock")
    :timeout(1)
    :send_safe()
  if not ok then
    print("err: ", res)
    return
  end
  print("Request 2 done: " .. inspect(res:json()))
end)

assert(cq:loop())
