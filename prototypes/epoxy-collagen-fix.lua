if not settings.startup["pylemon-epoxy-collagen-fix"].value then
    return
end

RECIPE("epoxy2"):set_result_amount("epoxy", 6 * 4)
