if not settings.startup["pylemon-nexelit-antimony-alloy-casting"].value then
    return
end

local hotairrecipes = require("helpers.hot-air")

RECIPE {
    type = "recipe",
    name = "nexelit-antimony-alloy-casting",
    category = "casting",
    ingredients = {
        {
            type = "item",
            name = "sand-casting",
            amount = 1
        },
        {
            type = "fluid",
            name = "molten-nexelit",
            amount = 100
        },
        {
            type = "item",
            name = "sb-oxide",
            amount = 10
        }
    },
    results = {
        {
            type = "item",
            name = "nxsb-alloy",
            amount = 10
        }
    },
    allow_productivity = true,
}:add_unlock("alloys-mk03")

hotairrecipes({ "nexelit-antimony-alloy-casting" })
