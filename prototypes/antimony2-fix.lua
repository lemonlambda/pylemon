if not settings.startup["pylemon-antimony2-fix"].value then
    return
end

RECIPE("sb-oxide-02"):set_result_amount("sb-oxide", 3 * 3)
RECIPE("sb-oxide-02a"):set_result_amount("sb-oxide", 10 * 3)
