local util = {}

---@generic T: table
---@param base T
---@param override? table
---@return T
function util.merge(base, override)
  if override == nil then return base end

  local out = {}
  for k, v in pairs(base) do
    out[k] = v
  end
  for k, v in pairs(override) do
    local cur = out[k]
    if
      type(cur) == "table"
      and type(v) == "table"
      and not util.is_sequence(cur)
      and not util.is_sequence(v)
    then
      out[k] = util.merge(cur, v)
    else
      out[k] = v
    end
  end
  return out
end

---@param t any
---@return boolean
function util.is_sequence(t)
  if type(t) ~= "table" then return false end
  local n = 0
  for k, _ in pairs(t) do
    if type(k) ~= "number" or math.tointeger(k) == nil or k <= 0 then
      return false
    end
    if k > n then n = k end
  end
  for i = 1, n do
    if rawget(t, i) == nil then return false end
  end
  return true
end

---@param s string
---@return string
function util.urlencode(s)
  return (
    s:gsub(
      "([^%w%-_%.~])",
      function(c) return string.format("%%%02X", string.byte(c)) end
    )
  )
end

---@param q table<string, req.QueryValue>
function util.encode_query(q)
  local parts = {}
  for k, v in pairs(q) do
    local key = util.urlencode(k)
    if type(v) == "table" then
      for _, item in ipairs(v) do
        parts[#parts + 1] = key .. "=" .. util.urlencode(tostring(item))
      end
    else
      parts[#parts + 1] = key .. "=" .. util.urlencode(tostring(v))
    end
  end
  table.sort(parts)
  return table.concat(parts, "&")
end

---@param url string
---@param q? table<string, req.QueryValue>
---@return string
function util.with_query(url, q)
  if not q then return url end
  local qs = util.encode_query(q)
  if qs == "" then return url end
  if url:find("?", 1, true) then
    return url .. "&" .. qs
  else
    return url .. "?" .. qs
  end
end

function util.hex_to_bytes(hex)
  return (hex:gsub("..", function(x) return string.char(tonumber(x, 16)) end))
end

function util.bytes_to_hex(bytes)
  return (
    bytes:gsub(
      ".",
      function(c) return string.format("%02X", string.byte(c)) end
    )
  )
end

return util
