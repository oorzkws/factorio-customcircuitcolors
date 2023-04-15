local lut = require("colors")
local wire_graphics = require("graphics")
-- Includes are above just to ensure CRC doesn't get weird
if not mods["WireShortcuts"] then
    return
end
-- Some utilities and our setting values
local colors
colors = {
    format = function(color)
        if not color then return end
        return {
            r = color.r or color[1],
            g = color.g or color[2],
            b = color.b or color[3]
        }
    end,
    invert = function(color)
        if not color then return end
        local rgb = colors.format(color)
        return {
            r = 255 - rgb.r,
            g = 255 - rgb.g,
            b = 255 - rgb.b
        }
    end,
    average = function(a, b)
        if not (a and b) then return end
        local rgb_a = colors.format(a)
        local rgb_b = colors.format(b)
        return {
            r = math.abs(rgb_a.r - rgb_b.r),
            g = math.abs(rgb_a.g - rgb_b.g),
            b = math.abs(rgb_a.g - rgb_b.b)
        }
    end,
    red = lut[settings.startup["cc-red-color"].value],
    green = lut[settings.startup["cc-green-color"].value],
    copper = lut[settings.startup["cc-copper-color"].value]
}
-- Calculate the "universal" color which will either be halfway between r/g or inverted copper
-- Depends on what settings are active
if colors.red or colors.green or colors.copper then
    colors.universal = { 200, 200, 200 }
end
colors.opposite = {
    red = colors.green,
    green = colors.red,
    copper = colors.universal,
    universal = colors.copper
}

---Changes the wire path to the generic white version and applies tint if necessary.
--- The return is a convenience, as the object passed to the function is also modified
---@param sprite_layer table single sprite layer
---@return table the processed sprite layer
local function process_layer(sprite_layer, tint, scale)
    if not sprite_layer then return end
    sprite_layer.filename = sprite_layer.filename:gsub("/%a+%-wire%-x", "/white-wire-x")
    sprite_layer.tint = tint or sprite_layer.tint
    if scale then
        sprite_layer.scale = (sprite_layer.scale or 1) * scale
    end
    process_layer(sprite_layer.hr_version, tint, scale)
    return sprite_layer
end

---Applies the various changes we want to make to a shortcut sprite
---@param sprite table sprite https://wiki.factorio.com/Types/Sprite
---@param base_tint table color https://wiki.factorio.com/Types/Color
local function process_sprite(sprite, base_tint, layer_tint)
    -- Convert non-layered to layered
    local layers = table.deepcopy(sprite.layers or { sprite })
    local output = {}
    -- Use a copied version with tint as the base layer if applicable
    if base_tint and #layers > 0 then
        local base_layer = table.deepcopy(layers[1])
        output = { process_layer(base_layer, base_tint, 1.05) }
    end
    -- Replace the file with the generic white version and then append to our sprite
    for _, layer in pairs(layers) do
        output[#output + 1] = process_layer(layer, layer_tint)
    end
    return {
        layers = output
    }
end

local tool_icons = {
    red = {
        {
            icon = wire_graphics.empty,
            icon_size = 128,
            scale = 0.5
        },
        {
            icon = wire_graphics.cut_wire,
            icon_size = 128,
            shift = {0, 0},
            scale = 0.5,
            tint = colors.red or lut.Red
        }        
    },
    green = {
        {
            icon = wire_graphics.empty,
            icon_size = 128,
            scale = 0.5
        },
        {
            icon = wire_graphics.cut_wire,
            icon_size = 128,
            shift = {0, 0},
            scale = 0.5,
            tint = colors.green or lut.Green
        }
    },
    copper = {
        {
            icon = wire_graphics.empty,
            icon_size = 128,
            scale = 0.5
        },
        {
            icon = wire_graphics.cut_wire,
            icon_size = 128,
            shift = {0, 0},
            scale = 0.5,
            tint = colors.copper or {239, 153, 34}
        }
    },
    universal = {
        {
            icon = wire_graphics.empty,
            icon_size = 128,
            scale = 0.5
        },
        {
            icon = wire_graphics.cut_wire,
            icon_size = 128,
            shift = {0, -18},
            scale = 0.5,
            tint = colors.red or lut.Red
        },
        {
            icon = wire_graphics.cut_wire,
            icon_size = 128,
            shift = {0, 18},
            scale = 0.5,
            tint = colors.green or lut.Green
        }
    }
}

for _, color in pairs({ "red", "green", "copper", "universal" }) do
    local rgb = colors[color]
    if rgb then
        local item = data.raw["item"]["fake-" .. color .. "-wire"]
        if item then
            item.icon = nil
            item.icon_size = 64
            item.icon_mipmaps = 4
            item.icons = {
                {
                    icon = wire_graphics.overlay,
                    tint = colors.invert(rgb)
                },
                {
                    icon = wire_graphics.connector
                }
            }
        end

        local shortcut = data.raw["shortcut"]["WireShortcuts-give-" .. color]
        if shortcut then
            shortcut.icon = process_sprite(shortcut.icon, { 0, 0, 0, 128 }, rgb)
            shortcut.small_icon = process_sprite(shortcut.small_icon, { 0, 0, 0, 128 }, rgb)
            shortcut.localised_name = {
                "item-name." .. color .. (color ~= "copper" and "-wire" or "-cable"),
                {"color." .. settings.startup["cc-" .. color .. "-color"].value:lower()}
            }
        end

        local tool = data.raw["selection-tool"]["wire-cutter-" .. color]
        if tool then
            local opposite = colors.opposite[color]
            tool.selection_color = rgb or tool.selection_color
            tool.alt_selection_color = opposite or tool.alt_selection_color
            tool.icon_size = nil
            tool.icon_mipmaps = nil
            tool.icon = nil
            tool.icons = tool_icons[color]
        end
    end
end
