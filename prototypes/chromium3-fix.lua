if not settings.startup["pylemon-chromium3-fix"].value then
    return
end

RECIPE("tier-4-chromite-sand"):set_fields {
    results = { {
        type = "item",
        name = "chromite-sand",
        amount = 55 * 3
    } }
}

RECIPE("reduction-chromium"):add_ingredient {
    type = "fluid",
    name = "chromite-pulp-07",
    amount = 20
}:remove_ingredient("light-oil")
