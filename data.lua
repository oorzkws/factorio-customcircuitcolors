local lut = {
    White   = {255,255,255},
    Gray    = {125,125,125},
    Black   = {25,25,25},
    Red     = {255,0,0},
    Orange  = {255,100,0},
    Yellow  = {255,225,0},
    Lime    = {150,255,0},
    Green   = {0,255,0},
    Cyan    = {0,255,225},
    Blue    = {0,0,255},
    Purple  = {150,0,255},
    Magenta = {255,0,255},
    Pink    = {255,100,255}
}
local bg_lut = {
    White=0,   Gray=1,     Black=2, Red=3,  Orange=4,
    Yellow=5,  Lime=6,     Green=7, Cyan=8, Blue=9,
    Purple=10, Magenta=11, Pink=12
}
local wire_targets = {"red", "green", "copper"}
local wire_graphics = {
    sprite    = "__CustomCircuitColors__/graphics/sprites/generic-wire.png",
    sprite_hr = "__CustomCircuitColors__/graphics/sprites/hr-generic-wire.png",
    overlay   = "__CustomCircuitColors__/graphics/icons/generic-wire-overlay.png",
    connector = "__CustomCircuitColors__/graphics/icons/generic-wire-connectors.png",
    slot_lut  = "__CustomCircuitColors__/graphics/color_luts/circuit-network-content-slot-lut.png"
}
for _, _target in pairs(wire_targets) do
    local wire_setting = settings.startup["cc-" .. _target .. "-color"].value
    if wire_setting == "Default" then goto continue end
    local wire_tint = lut[wire_setting]
    local lut_pos = {bg_lut[wire_setting] * 36, 0}
    local target = data.raw["utility-sprites"].default[_target .. "_wire"]
    target.filename = wire_graphics.sprite
    target.tint = wire_tint
    target.hr_version.filename = wire_graphics.sprite_hr
    target.hr_version.tint = wire_tint
    if _target ~= "copper" then
        local wire_icon = data.raw.item[_target .. "-wire"]
        wire_icon.icon = nil
        wire_icon.icon_size = 64
        wire_icon.icons = {
            {icon = wire_graphics.overlay, tint = wire_tint},
            {icon = wire_graphics.connector}
        }
        wire_icon.localised_name = {
            "item-name." .. _target .. "-wire",
            {"color." .. wire_setting:lower()}
        }
        content_slot = data.raw["gui-style"].default[_target .. "_circuit_network_content_slot"]
        content_slot.default_graphical_set.filename = wire_graphics.slot_lut
        content_slot.default_graphical_set.position = lut_pos
    end
    ::continue::
end