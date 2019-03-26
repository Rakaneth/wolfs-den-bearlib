local GameMap = require('class'):extend("GameMap")
local ROT = require('lib.rotLove.src.rot')
local Grid = ROT.Grid
local FOV = ROT.FOV.Precise
local Tiles = {
    floor = {
        walk = true,
        see = true,
        glyph = '.',
        name = "Floor",
    },
    wall = {
        walk = false,
        see = false,
        glyph = '#',
        name = "Wall",
    }
    ['door_closed'] = {
        walk = false,
        see = false,
        glyph = '+',
        name = "Door (closed)",
        color = "sepia"
    }
    ['door_open'] = {
        walk = true,
        see = true,
        glyph = '/',
        name = "Door (open)",
        color = "sepia"
    }
    ['stairs_down'] = {
        walk = true,
        see = true,
        glyph = '>',
        name = "Stairs down",
        color = "yellow"
    },
    ['stairs_up'] = {
        walk = true,
        see = true,
        glyph = '<',
        name = "Stairs up",
        color = "yellow"
    },
    mountain = {
        walk = false,
        see = true,
        glyph = '^',
        name = 'Mountain',
        color = "sepia"
    },
    forest = {
        walk = true,
        see = true,
        glyph = 5,
        name = 'Forest',
        color = 'green'
    }
}



function GameMap:init(opts)
    self._tiles = Grid()
    self.width = opts.width
    self.height = opts.height
    if opts.lit then
        self.lit = opts.lit
    else
        self.lit = true
    end
    
    local generators = {
        digger = ROT.Map.Digger,
        caves = ROT.Map.Cellular,
        world = require('map.worldgen'),
        fixed = require('map.fixed'),
    }

    local m = self

    local map_type = opts["map_type"] or "caves"
    local ctor = generators[map_type]
    local calbak = function(x, y, v)
        local cell_type = "floor"
        if v == 2 then
            cell_type = "door_closed"
        elseif v == 1 then
            cell_type = "wall"
        else
            cell_type = "floor"
        end
        m._tiles:setCell(x, y, cell_type)
    end

    if map_type == "caves" then
        opts.connected = true
        ctor:randomize(0.55)
        for i = 1, 5 do
            ctor:create(calbak)
        end
end