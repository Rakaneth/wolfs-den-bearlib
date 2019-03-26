local GameMap = require("class"):extend("GameMap")
local ROT = require("lib.rotLove.src.rot")
local Grid = ROT.Type.Grid
local PointSet = ROT.Type.PointSet
local FOV = ROT.FOV.Precise
local utils = require("utils")
local Tiles = {
    floor = {
        walk = true,
        see = true,
        glyph = ".",
        name = "Floor"
    },
    wall = {
        walk = false,
        see = false,
        glyph = "#",
        name = "Wall"
    },
    ["door_closed"] = {
        walk = false,
        see = false,
        glyph = "+",
        name = "Door (closed)",
        color = "sepia"
    },
    ["door_open"] = {
        walk = true,
        see = true,
        glyph = "/",
        name = "Door (open)",
        color = "sepia"
    },
    ["stairs_down"] = {
        walk = true,
        see = true,
        glyph = ">",
        name = "Stairs down",
        color = "yellow"
    },
    ["stairs_up"] = {
        walk = true,
        see = true,
        glyph = "<",
        name = "Stairs up",
        color = "yellow"
    },
    mountain = {
        walk = false,
        see = true,
        glyph = "^",
        name = "Mountain",
        color = "sepia"
    },
    forest = {
        walk = true,
        see = true,
        glyph = 5,
        name = "Forest",
        color = "green"
    },
    ["null_tile"] = {
        walk = false,
        see = false,
        glyph = 0
    }
}

function GameMap:init(opts)
    opts.connected = true
    self._tiles = Grid()
    self._explored = PointSet()
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
        world = require("map.worldgen"),
        fixed = require("map.fixed")
    }

    local m = self

    local map_type = opts["map_type"] or "caves"
    local ctor = generators[map_type](self.width, self.height, opts)
    local calbak = function(x, y, v)
        local cell_type
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
        ctor:randomize(0.55)
        for _ = 1, 5 do
            ctor:create(calbak)
        end
    elseif map_type == "digger" then
        ctor:create(calbak)
        local rooms = ctor:getRooms()
        for _, room in pairs(rooms) do
            room:getDoors(
                function(x, y)
                    self._tiles:setCell(x, y, "door_closed")
                end
            )
        end
    else
        ctor:create(calbak)
    end

    self.fov =
        FOV(
        function(fov, x, y)
            return m:canSee(x, y)
        end
    )
end

function GameMap:isOOB(x, y)
    return not (utils.between(1, x, self.width) and
        utils.between(1, y, self.height))
end

function GameMap:getTile(x, y)
    local cell_type
    if self:isOOB(x, y) then
        cell_type = "null_tile"
    else
        cell_type = self._tiles:getCell(x, y)
    end
    return Tiles[cell_type]
end

function GameMap:setTile(x, y, cell_type)
    self._tiles:setCell(x, y, cell_type)
end

function GameMap:updateFOV(entity)
    if entity:has("vision") then
        entity.visible = PointSet()
    end
    self.fov:compute(
        entity.x,
        entity.y,
        entity:getStat("vision"),
        function(x, y)
            entity.visible:push(x, y)
        end
    )
end

function GameMap:canSee(x, y)
    local tile = self:getTile(x, y)
    return tile.see
end

function GameMap:canWalk(x, y)
    local tile = self:getTile(x, y)
    return tile.walk
end

function GameMap:explore(x, y)
    self._explored:push(x, y)
end

function GameMap:isExplored(x, y)
    return self._explored:find(x, y)
end

return GameMap
