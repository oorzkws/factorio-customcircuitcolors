local lut = {
    White   = {255, 255, 255},
    Gray    = {125, 125, 125},
    Black   = {25, 25, 25},
    Red     = {255, 0, 0},
    Orange  = {255, 100, 0},
    Yellow  = {255, 225, 0},
    Lime    = {150, 255, 0},
    Green   = {0, 255, 0},
    Cyan    = {0, 255, 225},
    Blue    = {0, 0, 255},
    Purple  = {150, 0, 255},
    Magenta = {255, 0, 255},
    Pink    = {255, 100, 255}
}

-- Spritesheet position for the circuit value background on the pole tooltip
local bg_lut = {
    -- White = {0, 0}
    -- Gray = {36, 0}
    -- etc
}

-- In Factorio this order is deterministic, in normal Lua it is not
local spritesheet_pos = 0
for color, value in pairs(lut) do
    -- Add sprite with color for locale, thanks to Deadlock989 for the suggestion
    data:extend({{
        type = "sprite",
        name = "ccc-color-" .. color:lower(),
        filename = "__CustomCircuitColors__/graphics/icons/circle.png",
        tint = value,
        priority = "extra-high",
        flags = {"gui-icon"},
        width = 64,
        height = 64,
        mipmap_count = 0
    }})
    -- Add bg_lut entry
    bg_lut[color] = {spritesheet_pos, 0}
    spritesheet_pos = spritesheet_pos + 36
end

local wire_graphics = {
    sprite    = "__CustomCircuitColors__/graphics/sprites/generic-wire.png",
    sprite_hr = "__CustomCircuitColors__/graphics/sprites/hr-generic-wire.png",
    overlay   = "__CustomCircuitColors__/graphics/icons/generic-wire-overlay.png",
    connector = "__CustomCircuitColors__/graphics/icons/generic-wire-connectors.png",
    slot_lut  = "__CustomCircuitColors__/graphics/color_luts/circuit-network-content-slot-lut.png"
}

for _, wire_type in pairs({"red", "green", "copper"}) do
    local wire_setting = settings.startup["cc-" .. wire_type .. "-color"].value

    if wire_setting ~= "Default" then
        -- Modify wire sprite
        local wire_tint = lut[wire_setting]
        local wire_sprite = data.raw["utility-sprites"].default[wire_type .. "_wire"]
        wire_sprite.filename = wire_graphics.sprite
        wire_sprite.tint = wire_tint
        wire_sprite.hr_version.filename = wire_graphics.sprite_hr
        wire_sprite.hr_version.tint = wire_tint

        if wire_type ~= "copper" then
            -- Modify red/green wire items
            local wire_item = data.raw.item[wire_type .. "-wire"]
            wire_item.localised_name = {
                "item-name." .. wire_type .. "-wire",
                {"color." .. wire_setting:lower()}
            }
            wire_item.icon = nil
            wire_item.icon_size = 64
            wire_item.icons = {
                {
                    icon = wire_graphics.overlay,
                    tint = wire_tint
                },
                {
                    icon = wire_graphics.connector
                }
            }
            -- Circuit value background on tooltip
            local content_slot = data.raw["gui-style"].default[wire_type .. "_circuit_network_content_slot"]
            content_slot.default_graphical_set.filename = wire_graphics.slot_lut
            content_slot.default_graphical_set.position = bg_lut[wire_setting]
        end
    end
end