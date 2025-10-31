if settings.startup["pylemon-trains-storage-size-cargo-standardization"].value then
    ENTITY("cargo-wagon"):set_fields {
        inventory_size = 40
    }

    ENTITY("mk02-wagon"):set_fields {
        inventory_size = 80,
    }

    ENTITY("ht-generic-wagon"):set_fields {
        inventory_size = 160,
    }

    ENTITY("mk04-wagon"):set_fields {
        inventory_size = 240,
    }
end

if settings.startup["pylemon-trains-storage-size-fluid-standardization"].value then
    ENTITY("fluid-wagon"):set_fields {
        capacity = 50000
    }

    ENTITY("mk02-fluid-wagon"):set_fields {
        capacity = 100000,
    }

    ENTITY("ht-generic-fluid-wagon"):set_fields {
        capacity = 200000,
    }

    ENTITY("mk04-fluid-wagon"):set_fields {
        capacity = 400000,
    }
end
