if not settings.startup["pylemon-kevlar2-fix"].value then
    return
end

RECIPE("kevlar-2"):set_result_amount("kevlar", 5 * 4)
