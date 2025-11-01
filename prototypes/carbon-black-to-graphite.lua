if not settings.startup["pylemon-carbon-black-to-graphite"].value then
    return
end

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
            amount = 100
        },
        {
            type = "fluid",
            name = "phosphoric-acid",
            amount = 100
        }
    },
    results = {
        {
            type = "fluid",
            name = "sulfuric-phosphoric-acid-mixture",
            amount = 100
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
            amount = 100
        },
        {
            type = "fluid",
            name = "sulfuric-phosphoric-acid-mixture",
            amount = 100
        },
    },
    results = {
        {
            type = "fluid",
            name = "carbon-black-solution",
            amount = 100
        }
    }
}:add_unlock("graphene")

RECIPE {
    type = "recipe",
    name = "centrifuging-carbon-black-solution",
    category = "centrifuging",
    ingredients = {
        {
            type = "fluid",
            name = "carbon-black-solution",
            amount = 100
        }
    },
    results = {
        {
            type = "item",
            name = "graphite",
            amount = 100
        },
        {
            type = "fluid",
            name = "tar",
            amount = 100
        }
    },
    main_product = "graphite",
}:add_unlock("graphene")
