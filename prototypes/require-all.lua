if not settings.startup["pylemon-the-final"].value then
    return
end

-- Haha no the final!!
if true then
    return
end

local target = "space-science"
local include_fluids = false
local include_hidden = true
local only_products_universe = true

-- Which prototype types count as "items"
local ITEM_TYPES = {
    ["item"] = true,
    ["tool"] = true,
    ["ammo"] = true,
    ["capsule"] = true,
    ["gun"] = true,
    ["module"] = true,
    ["armor"] = true,
    ["repair-tool"] = true,
    ["rail-planner"] = true,
    ["item-with-entity-data"] = true,
    ["item-with-label"] = true,
    ["item-with-inventory"] = true,
    ["selection-tool"] = true,
    ["blueprint"] = true,
    ["deconstruction-item"] = true,
    ["upgrade-item"] = true,
    ["blueprint-book"] = true,
    ["copy-paste-tool"] = true,
    ["spidertron-remote"] = true,
    ["spidertron-remote-selection-tool"] = true,
    ["item-with-tags"] = true,
    ["item-with-type"] = true,
    ["script-item"] = true,
}

-- Normalize a single ingredient/product entry to {type="item"|"fluid", name=...}
local function normalize_io(e)
    if not e then return nil end
    if type(e) == "table" then
        if e.name then
            local t = e.type or "item"
            if t == "item" or (include_fluids and t == "fluid") then
                return { type = t, name = e.name }
            end
        else
            local name = e[1]
            if type(name) == "string" then
                return { type = "item", name = name }
            end
        end
    elseif type(e) == "string" then
        return { type = "item", name = e }
    end
    return nil
end

-- Factorio 2.0: only top-level ingredients/results (or result)
local function recipe_ios(r)
    local ing_set, prod_set = {}, {}

    local function add(arr, set)
        if not arr then return end
        for _, e in pairs(arr) do
            local n = normalize_io(e)
            if n then set[n.name] = true end
        end
    end

    add(r.ingredients, ing_set)

    if r.results then
        add(r.results, prod_set)
    elseif r.result then
        local t = r.result_is_fluid and "fluid" or "item"
        if t == "item" or (include_fluids and t == "fluid") then
            prod_set[r.result] = true
        end
    end

    local ings, prods = {}, {}
    for k in pairs(ing_set) do ings[#ings + 1] = k end
    for k in pairs(prod_set) do prods[#prods + 1] = k end
    table.sort(ings); table.sort(prods)
    return ings, prods
end

-- Universe: either all item prototypes (and fluids if enabled) or only things that appear as any recipe product
local function collect_universe()
    local universe = {}
    if not only_products_universe then
        for t, tab in pairs(data.raw) do
            if ITEM_TYPES[t] then
                for name, _ in pairs(tab) do
                    universe[name] = true
                end
            end
        end
        if include_fluids and data.raw.fluid then
            for name, _ in pairs(data.raw.fluid) do
                universe[name] = true
            end
        end
    else
        if data.raw.recipe then
            for _, r in pairs(data.raw.recipe) do
                if include_hidden or not r.hidden then
                    local _, prods = recipe_ios(r)
                    for _, p in ipairs(prods) do
                        universe[p] = true
                    end
                end
            end
        end
    end
    return universe
end

-- Reverse graph: product -> {ingredient = true, ...}
local function build_reverse_graph()
    local rev = {}
    local function parents_of(prod)
        local s = rev[prod]; if not s then
            s = {}; rev[prod] = s
        end; return s
    end
    if not data.raw.recipe then return rev end
    for _, r in pairs(data.raw.recipe) do
        if include_hidden or not r.hidden then
            local ings, prods = recipe_ios(r)
            if #prods > 0 and #ings > 0 then
                for _, p in ipairs(prods) do
                    local P = parents_of(p)
                    for _, ing in ipairs(ings) do P[ing] = true end
                end
            end
        end
    end
    return rev
end

-- Forward graph: ingredient -> {product = true, ...}
local function build_forward_graph()
    local fwd = {}
    local function children_of(ing)
        local s = fwd[ing]; if not s then
            s = {}; fwd[ing] = s
        end; return s
    end
    if not data.raw.recipe then return fwd end
    for _, r in pairs(data.raw.recipe) do
        if include_hidden or not r.hidden then
            local ings, prods = recipe_ios(r)
            if #prods > 0 and #ings > 0 then
                for _, ing in ipairs(ings) do
                    local C = children_of(ing)
                    for _, p in ipairs(prods) do C[p] = true end
                end
            end
        end
    end
    return fwd
end

-- Backwards reachability over the reverse graph (what can ultimately craft into target?)
local function backwards_reachable(rev, target_name)
    local visited = {}
    local q = {}
    visited[target_name] = true
    if rev[target_name] then
        q[1] = target_name
        local h, t = 1, 1
        while h <= t do
            local cur = q[h]; h = h + 1
            local parents = rev[cur]
            if parents then
                for parent, _ in pairs(parents) do
                    if not visited[parent] then
                        visited[parent] = true
                        t = t + 1
                        q[t] = parent
                    end
                end
            end
        end
    end
    return visited
end

local function set_minus(A, B)
    local out = {}
    for k, _ in pairs(A) do if not B[k] then out[k] = true end end
    return out
end

-- ----- SCC condensation over forward graph restricted to S -----
local function highest_layer_or_next(S, fwd)
    -- Build adjacency restricted to S
    local id_map, nodes = {}, {}
    for name in pairs(S) do
        id_map[name] = #nodes + 1
        nodes[#nodes + 1] = name
    end

    local N = #nodes
    if N == 0 then return {} end

    -- Build restricted adjacency list (indices)
    local adj = {}
    for i = 1, N do adj[i] = {} end
    for i = 1, N do
        local u = nodes[i]
        local ch = fwd[u]
        if ch then
            for vname in pairs(ch) do
                local j = id_map[vname]
                if j then
                    local a = adj[i]; a[#a + 1] = j
                end
            end
        end
    end

    -- Tarjan SCC
    local idx, stack, onstack = 0, {}, {}
    local index, lowlink, comp_id = {}, {}, {}
    local comp_count = 0

    local function strongconnect(v)
        idx = idx + 1
        index[v] = idx
        lowlink[v] = idx
        stack[#stack + 1] = v
        onstack[v] = true

        for _, w in ipairs(adj[v]) do
            if not index[w] then
                strongconnect(w)
                if lowlink[w] < lowlink[v] then lowlink[v] = lowlink[w] end
            elseif onstack[w] and index[w] < lowlink[v] then
                lowlink[v] = index[w]
            end
        end

        if lowlink[v] == index[v] then
            comp_count = comp_count + 1
            while true do
                local w = stack[#stack]; stack[#stack] = nil
                onstack[w] = nil
                comp_id[w] = comp_count
                if w == v then break end
            end
        end
    end

    for v = 1, N do
        if not index[v] then strongconnect(v) end
    end

    -- Build condensed DAG (components as nodes)
    local comp_out = {}
    local comp_members = {}
    for c = 1, comp_count do
        comp_out[c] = {}
        comp_members[c] = {}
    end
    for i = 1, N do
        local ci = comp_id[i]
        comp_members[ci][#comp_members[ci] + 1] = nodes[i]
        for _, j in ipairs(adj[i]) do
            local cj = comp_id[j]
            if ci ~= cj then comp_out[ci][cj] = true end
        end
    end

    -- Find sink components (no outgoing edges)
    local sinks = {}
    for c = 1, comp_count do
        local outdeg = 0
        for _ in pairs(comp_out[c]) do
            outdeg = 1; break
        end
        if outdeg == 0 then sinks[#sinks + 1] = c end
    end

    if #sinks > 0 then
        -- Highest intermediates = flatten members of sink components
        local keep = {}
        for _, c in ipairs(sinks) do
            for _, name in ipairs(comp_members[c]) do keep[name] = true end
        end
        return keep
    end

    -- Fallback: peel one layer (shouldn't happen with SCC DAG, but safe)
    -- Compute outdegree counts, remove (none), then pick next sinks.
    local outdeg = {}
    for c = 1, comp_count do
        local deg = 0
        for _ in pairs(comp_out[c]) do deg = deg + 1 end
        outdeg[c] = deg
    end
    -- Since we had no sinks, pick components with minimal outdegree as fallback
    local min_deg = nil
    for c = 1, comp_count do
        local d = outdeg[c]
        if not min_deg or d < min_deg then min_deg = d end
    end
    local keep = {}
    for c = 1, comp_count do
        if outdeg[c] == min_deg then
            for _, name in ipairs(comp_members[c]) do keep[name] = true end
        end
    end
    return keep
end

-- ==== Compute sets ====
local universe = collect_universe()
if not universe[target] then
    log("[reach] WARNING: target '" .. target .. "' is not in universe (check setting).")
end

local rev = build_reverse_graph()
local reached = backwards_reachable(rev, target)
local missing = set_minus(universe, reached)

-- Filter to actual items (avoid ghosts) and drop the target itself
missing[target] = nil
for name in pairs(missing) do
    local exists = false
    for t, tab in pairs(data.raw) do
        if ITEM_TYPES[t] and tab[name] then
            exists = true; break
        end
    end
    if not exists then missing[name] = nil end
end

-- Build forward graph and pick highest intermediates (with SCC condensation)
local fwd = build_forward_graph()
local hi_missing = highest_layer_or_next(missing, fwd)

-- === Build ingredient list from chosen set ===
local ingredients = {}
for name, _ in pairs(hi_missing) do
    ingredients[#ingredients + 1] = { type = "item", name = name, amount = 1 }
end
table.sort(ingredients, function(a, b) return a.name < b.name end)

-- === Prototypes ===
ITEM {
    type = "item",
    name = "the-final",
    icon = "__pylemon__/graphics/icons/thefinal.png",
    icon_size = 64,
    stack_size = 1000
}

RECIPE {
    type = "recipe",
    name = "the-final",
    ingredients = ingredients,
    category = "quantum",
    energy_required = 60 * 60,
    results = {
        { type = "item", name = "the-final", amount = 1000 }
    },
    enabled = true,
}:add_unlock("space-science-pack")

RECIPE("space-science-pack"):add_ingredient({ type = "item", name = "the-final", amount = 1 })

-- === Log summary ===
local function count_set(s)
    local n = 0; for _ in pairs(s) do n = n + 1 end; return n
end
log(string.format(
    "[reach] target=%s  missing=%d  chosen(highest-or-next)=%d  (universe=%d, reachable=%d)",
    target, count_set(missing), #ingredients, count_set(universe), count_set(reached)
))
