---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field

local util = require("util")

describe("util.is_sequence", function()
  it("should return false for non-tables", function()
    assert.is_false(util.is_sequence(nil))
    assert.is_false(util.is_sequence(42))
    assert.is_false(util.is_sequence("string"))
    assert.is_false(util.is_sequence(function() end))
    assert.is_false(util.is_sequence(true))
    assert.is_false(util.is_sequence(io.stdout))
  end)

  it(
    "should return true for empty tables",
    function() assert.is_true(util.is_sequence {}) end
  )

  it("should return true for simple sequences", function()
    assert.is_true(util.is_sequence { 1 })
    assert.is_true(util.is_sequence { 1, 2, 3 })
    assert.is_true(util.is_sequence { "a", "b", "c" })
    assert.is_true(util.is_sequence { true, false, nil })
  end)

  it("should handle holes in sequences", function()
    assert.is_false(util.is_sequence { 1, nil, 3 })
    assert.is_false(util.is_sequence { [1] = "a", [3] = "c" })
  end)

  it("should handle non-integer keys", function()
    assert.is_false(util.is_sequence { [2.5] = "a" })
    assert.is_false(util.is_sequence { [1] = "a", [1.5] = "b" })
    assert.is_false(util.is_sequence { [0.5] = "a" })
  end)

  it("should handle negative or zero keys", function()
    assert.is_false(util.is_sequence { [-1] = "a", [0] = "b", [1] = "c" })
    assert.is_false(util.is_sequence { [0] = "a" })
  end)

  it("should handle metatables", function()
    local t = setmetatable(
      { 1, 2, 3 },
      { __index = function() return "def" end }
    )
    assert.is_true(util.is_sequence(t))
    local t2 = setmetatable({ 1, nil, 3 }, {
      __index = function() return "filled" end,
    })
    assert.is_false(util.is_sequence(t2))
  end)

  it("should work with nested tables as values", function()
    local t = {
      { 1, 2, 3 },
      { a = 1, b = 2 },
      "string",
    }
    assert.is_true(util.is_sequence(t))
  end)
end)

describe("util.merge", function()
  it("should return base when override is nil", function()
    local base = { a = 1, b = 2 }
    local result = util.merge(base, nil)
    assert.are.same(base, result)
  end)

  it("should shallow merge simple tables", function()
    local base = { a = 1, b = 2 }
    local override = { b = 3, c = 4 }
    local expected = { a = 1, b = 3, c = 4 }
    assert.are.same(expected, util.merge(base, override))
  end)

  it("should deep merge nested tables", function()
    local base = { a = { x = 1, y = 2 }, b = 3 }
    local override = { a = { y = 20, z = 30 }, c = 4 }
    local expected = { a = { x = 1, y = 20, z = 30 }, b = 3, c = 4 }
    assert.are.same(expected, util.merge(base, override))
  end)

  it("should not deep merge sequences", function()
    local base = { items = { 1, 2, 3 } }
    local override = { items = { 4, 5, 6 } }
    local result = util.merge(base, override)
    assert.are.same({ 4, 5, 6 }, result.items)
  end)

  it("should handle mixed tables with sequences and maps", function()
    local base = {
      array = { 1, 2, 3 },
      map = { x = 1, y = 2 },
      value = "hello",
    }
    local override = {
      array = { 4, 5 },
      map = { y = 20, z = 30 },
      value = "world",
    }
    local result = util.merge(base, override)
    assert.are.same(
      { array = { 4, 5 }, map = { x = 1, y = 20, z = 30 }, value = "world" },
      result
    )
  end)

  it("should handle empty tables in merge", function()
    assert.are.same({}, util.merge({}, {}))
    assert.are.same({ a = 1 }, util.merge({}, { a = 1 }))
    assert.are.same({ a = 1 }, util.merge({ a = 1 }, {}))
  end)

  it("should create new table without copying metatable", function()
    local base = setmetatable({ a = 1 }, {
      __index = function() return "default" end,
    })
    local result = util.merge(base, { b = 2 })

    assert.are.same({ a = 1, b = 2 }, result)
    assert.is_nil(getmetatable(result))
    assert.are.equal("default", base.nonexistent)
    assert.is_nil(result.nonexistent)
  end)
end)

describe("util.urlencode", function()
  it(
    "should urencode spaces",
    function()
      assert.are.equal(util.urlencode("hello world!"), "hello%20world%21")
    end
  )

  it(
    "should handle unicode",
    function()
      assert.are.equal(
        util.urlencode("привет"),
        "%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82"
      )
    end
  )
end)

describe("util.encode_query", function()
  it(
    "should urencode query",
    function()
      assert.are.equal(
        util.encode_query({ key1 = "value1", key2 = "value2" }),
        "key1=value1&key2=value2"
      )
    end
  )
end)
