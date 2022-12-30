local lut = {
    Red = {r = 1, g = 0, b = 0},
    Green = {r = 0, g = 1, b = 0},
    Blue = {r = 0, g = 0, b = 1},
    Cyan = {r = 0, g = 1, b = 1},
    Magenta = {r = 1, g = 0, b = 1},
    Yellow = {r = 1, g = 1, b = 0},
    Gray = {r = 1, g = 1, b = 1}   
}
local bg_lut = {
    Red = {111, 36},
    Green = {111, 108},
    Blue = {221, 36},
    Cyan = {221, 72},
    Magenta = {147, 36},
    Yellow = {111, 72},
    Gray = {111, 0}
}

local red_setting = settings.startup["cc-red-color"].value
local red_tint = lut[red_setting]
local red_icon = data.raw.item["red-wire"]
local red_wire = data.raw["utility-sprites"].default.red_wire
red_icon.icon = nil
red_icon.icon_size = 64
red_icon.icons = {
    {
        icon = "__CustomCircuitColors__/graphics/icons/generic-wire-overlay.png",
        tint = red_tint
    },
    {
        icon = "__CustomCircuitColors__/graphics/icons/generic-wire-connectors.png"
    }
}
red_icon.localised_name = {
    "item-name.red-wire", {"color." .. red_setting:lower()}
}
red_wire.filename = "__CustomCircuitColors__/graphics/sprites/generic-wire.png"
red_wire.tint = red_tint
red_wire.hr_version.filename = "__CustomCircuitColors__/graphics/sprites/hr-generic-wire.png"
red_wire.hr_version.tint = red_tint
data.raw["gui-style"].default.red_circuit_network_content_slot.default_graphical_set.position = bg_lut[red_setting]

local green_setting = settings.startup["cc-green-color"].value
local green_tint = lut[green_setting]
local green_icon = data.raw.item["green-wire"]
local green_wire = data.raw["utility-sprites"].default.green_wire
green_icon.icon = nil
green_icon.icon_size = 64
green_icon.icons = {
    {
        icon = "__CustomCircuitColors__/graphics/icons/generic-wire-overlay.png",
        tint = green_tint
    },
    {
        icon = "__CustomCircuitColors__/graphics/icons/generic-wire-connectors.png"
    }
}
green_icon.localised_name = {
    "item-name.green-wire", {"color." .. green_setting:lower()}
}
green_wire.filename = "__CustomCircuitColors__/graphics/sprites/generic-wire.png"
green_wire.tint = green_tint
green_wire.hr_version.filename = "__CustomCircuitColors__/graphics/sprites/hr-generic-wire.png"
green_wire.hr_version.tint = green_tint
data.raw["gui-style"].default.green_circuit_network_content_slot.default_graphical_set.position = bg_lut[green_setting]

local elec_setting = settings.startup["cc-elec-color"].value
if elec_setting ~= "Default" then
    local elec_tint = lut[elec_setting]
    local elec_wire = data.raw["utility-sprites"].default.copper_wire
    elec_wire.filename = "__CustomCircuitColors__/graphics/sprites/generic-wire.png"
    elec_wire.tint = elec_tint
    elec_wire.hr_version.filename = "__CustomCircuitColors__/graphics/sprites/hr-generic-wire.png"
    elec_wire.hr_version.tint = elec_tint
end