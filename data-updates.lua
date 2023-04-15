local lut = require("colors")
local wire_graphics = require("graphics")

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

for _, wire_type in pairs({"red", "green", "copper"}) do
    local wire_setting = settings.startup["cc-" .. wire_type .. "-color"].value

    if wire_setting ~= "Default" then
        -- Modify wire sprite
        local wire_tint = lut[wire_setting]
        local wire_sprite = data.raw["utility-sprites"].default[wire_type .. "_wire"]
        local filename = wire_graphics.sprite
        local hr_filename = wire_graphics.sprite_hr
        if mods["ThickerLines"] then
            if wire_type ~= "copper" and settings.startup["thicker-lines-circuit"].value or settings.startup["thicker-lines-copper"].value then
                filename = wire_graphics.sprite_thick
                hr_filename = wire_graphics.sprite_thick_hr
            end
        end

        wire_sprite.filename = filename
        wire_sprite.tint = wire_tint
        wire_sprite.hr_version.filename = hr_filename
        wire_sprite.hr_version.tint = wire_tint

        local wire_name = wire_type .. (wire_type ~= "copper" and "-wire" or "-cable")
        -- Modify red/green wire items
        local wire_item = data.raw.item[wire_name]
        wire_item.localised_name = {
            "item-name.ccc-" .. wire_name,
            {"color." .. wire_setting:lower()}
        }
        wire_item.icon = nil
        wire_item.icon_size = 64
        wire_item.icon_mipmaps = 4
        wire_item.icons = {
            {
                icon = wire_graphics.overlay,
                tint = wire_tint
            },
            {
                icon = wire_graphics.connector
            }
        }
        if wire_type ~= "copper" then
            -- Circuit value background on tooltip
            local content_slot = data.raw["gui-style"].default[wire_type .. "_circuit_network_content_slot"]
            content_slot.default_graphical_set.filename = wire_graphics.slot_lut
            content_slot.default_graphical_set.position = bg_lut[wire_setting]
        end
    end
end

-- Compat stuff goes here
require("compatibility.wireshortcuts")