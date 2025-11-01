if not settings.startup["pylemon-carbon-black-to-graphite"].value then
    return
end



-- 40 sulfuric + 10 phosphoric --> 50 spam 
--      chem plant
--
-- spam + carbon-black + fluorine -> carbon-black-solution 
--      mixer 
--
-- carbon-black-solution + peroxide + water -> pre-graphite + steam
--      centrifuge 
--
-- precarbon-black + hcl -> graphite
--      evaporator


ITEM {
    type = "item",
    name = "pre-graphite",
    icon = "__pylemon__/graphics/icons/thefinal.png",
    icon_size = 64,
    stack_size = 1000
}


FLUID {
    type = "fluid",
    name = "sulfuric-phosphoric-acid-mixture",
    icon = "__pyfusionenergygraphics__/graphics/icons/soda-ash.png",
    icon_size = 32,
    default_temperature = 10,
    base_color = { 1.0, 1.0, 1.0, 1.0 },
    flow_color = { 1.0, 1.0, 1.0, 1.0 }
}

FLUID {
    type = "fluid",
    name = "carbon-black-solution",
    icon = "__pyraworesgraphics__/graphics/icons/coal-under-pulp.png",
    icon_size = 32,
    default_temperature = 10,
    base_color = { 1.0, 1.0, 1.0, 1.0 },
    flow_color = { 1.0, 1.0, 1.0, 1.0 }
}


RECIPE {
    type = "recipe",
    name = "sulfuric-phosphoric-acid-solution",
    category = "chemistry",
    ingredients = {
        {
            type = "fluid",
            name = "sulfuric-acid",
            amount = 40
        },
        {
            type = "fluid",
            name = "phosphoric-acid",
            amount = 10
        }
    },
    results = {
        {
            type = "fluid",
            name = "sulfuric-phosphoric-acid-mixture",
            amount = 50
        }
    }
}:add_unlock("graphene")

RECIPE {
    type = "recipe",
    name = "carbon-black-addition",
    category = "chemistry",
    ingredients = {
        {
            type = "item",
            name = "carbon-black",
            amount = 4
        },
        {
            type = "fluid",
            name = "sulfuric-phosphoric-acid-mixture",
            amount = 20
        },
        {
            type = "fluid",
            name = "fluorine-gas",
            amount = 5
        }
    },
    results = {
        {
            type = "fluid",
            name = "carbon-black-solution",
            amount = 40
        }
    }
}:add_unlock("graphene")

RECIPE {
    type = "recipe",
    name = "mixing-carbon-black-solution",
    category = "mixer",
    ingredients = {
        {
            type = "fluid",
            name = "carbon-black-solution",
            amount = 50,
        },
        {
            type = "fluid",
            name = "hydrogen-peroxide",
            amount = 10
        },
        {
            type = "fluid",
            name = "water",
            amount = 20
        },
    },
    results = {
        {
            type = "item",
            name = "pre-graphite",
            amount = 9
        },
        {
            type = "fluid",
            name = "steam",
            amount = 20
        }
    },
    main_product = "pre-graphite",
    allow_productivity = true,
}:add_unlock("graphene")

RECIPE {
    type = "recipe",
    name = "evaporating-pre-graphite",
    category = "centrifuging",
    ingredients = {
        {
            type = "item",
            name = "pre-graphite",
            amount = 2
        },
        {
            type = "fluid",
            name = "hydrogen-chloride",
            amount = 20
        },
    },
    results = {
        {
            type = "item",
            name = "graphite",
            amount = 5
        },
        {
            type = "fluid",
            name = "coal-gas",
            amount = 10
        }
    },
    main_product = "graphite",
    allow_productivity = true,
}:add_unlock("graphene")
