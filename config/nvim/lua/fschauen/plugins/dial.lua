---Create a right hand side for `dial` key maps.
---@param cmd string: name of a function from `dial.map`.
---@param suffix? string: keys to add after `dial`s mapping.
---@return function
local dial_cmd = function(cmd, suffix)
  suffix = suffix or ""
  return function()
    return require("dial.map")[cmd]() .. suffix
  end
end

---Make a new augent that cycles over the given elements.
---@param elements string[]: the elements to cycle.
---@return table: @see `dial.types.Augend`
local cyclic_augend = function(elements)
  return require("dial.augend").constant.new {
    elements = elements,
    word = true,
    cyclic = true,
  }
end

local weekdays = {
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
}

local weekdays_short = vim.tbl_map(function(s)
  return s:sub(1, 3)
end, weekdays)

return {
  "monaqa/dial.nvim",

  keys = {
    -- stylua: ignore start
    { "<c-a>", dial_cmd("inc_normal"),         expr = true, desc = " Increment" },
    { "<c-x>", dial_cmd("dec_normal"),         expr = true, desc = " Decrement" },

    { "<c-a>", dial_cmd("inc_visual", "gv"),   expr = true, desc = " Increment", mode = "v" },
    { "<c-x>", dial_cmd("dec_visual", "gv"),   expr = true, desc = " Decrement", mode = "v" },

    { "g<c-a>", dial_cmd("inc_gvisual", "gv"), expr = true, desc = " Increment", mode = "v" },
    { "g<c-x>", dial_cmd("dec_gvisual", "gv"), expr = true, desc = " Decrement", mode = "v" },
    -- stylua: ignore end
  },

  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group {
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.integer.alias.binary,
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%d/%m/%Y"],
        augend.date.alias["%d.%m.%Y"],
        cyclic_augend(weekdays),
        cyclic_augend(weekdays_short),
      },
    }
  end,
}
