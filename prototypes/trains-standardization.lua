
if not settings.startup["pylemon-trains-standardization"].value then
  return
end

ENTITY("cargo-wagon"):set_fields{
  inventory_size = 40
}
ENTITY("fluid-wagon"):set_fields{
  capacity = 50000
}

local collision_box_cargo = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"].collision_box)
local selection_box_cargo = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"].selection_box)
local connection_distance_cargo = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"].connection_distance)
local joint_distance_cargo = table.deepcopy(data.raw["cargo-wagon"]["cargo-wagon"].joint_distance)

local collision_box_fluid = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"].collision_box)
local selection_box_fluid = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"].selection_box)
local connection_distance_fluid = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"].connection_distance)
local joint_distance_fluid = table.deepcopy(data.raw["fluid-wagon"]["fluid-wagon"].joint_distance)

ENTITY("mk02-wagon"):set_fields{
  inventory_size = 80,
  collision_box = collision_box_cargo,
  selection_box = selection_box_cargo,
    connection_distance = connection_distance_cargo,
    joint_distance = joint_distance_cargo,
}
ENTITY("mk02-fluid-wagon"):set_fields{
  capacity = 100000,
  collision_box = collision_box_fluid,
  selection_box = selection_box_fluid,
    connection_distance = connection_distance_fluid,
    joint_distance = joint_distance_fluid,
}

if mods.pyhightech then
  ENTITY("ht-generic-wagon"):set_fields{
    inventory_size = 160,
    collision_box = collision_box_cargo,
    selection_box = selection_box_cargo,
    connection_distance = connection_distance_cargo,
    joint_distance = joint_distance_cargo,
  }
  ENTITY("ht-generic-fluid-wagon"):set_fields{
    capacity = 200000,
    collision_box = collision_box_fluid,
    selection_box = selection_box_fluid,
    connection_distance = connection_distance_fluid,
    joint_distance = joint_distance_fluid,
  }
end

if mods.pyalternativeenergy then
  ENTITY("mk04-wagon"):set_fields{
    inventory_size = 240,
    collision_box = collision_box_cargo,
    selection_box = selection_box_cargo,
    connection_distance = connection_distance_cargo,
    joint_distance = joint_distance_cargo,
  }
  ENTITY("mk04-fluid-wagon"):set_fields{
    capacity = 400000,
    collision_box = collision_box_fluid,
    selection_box = selection_box_fluid,
    connection_distance = connection_distance_fluid,
    joint_distance = joint_distance_fluid,
  }
end

