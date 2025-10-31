if not settings.startup["pylemon-coal3-and-4-fix"].value then
    return
end

RECIPE("coarse-to-coal"):set_result_amount("coal", 6 * 25)
RECIPE("coal-pulp-05-refining"):set_result_amount("coal", 20 * 25)
RECIPE("filter-coal-pulp-01"):set_result_amount("coal", 40 * 25)
RECIPE("simik-coal"):set_result_amount("coal-pulp-03-barrel", 1):set_result_amount("cf", 24):set_ingredient_amount("bio-sample", 3):set_ingredient_amount("raw-coal", 180)
