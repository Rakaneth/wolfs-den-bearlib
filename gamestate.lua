local utils = require("utils")

local Game = {
    things = {},
    maps = {},
    engine = {},
    scheduler = {},
    cur_map_ID = "no map",
    map_dirty = true
}

function Game:add_entity(entity)
    self.things[entity.id] = entity
end

function Game:remove_entity(entity)
    self.things[entity.id] = nil
end

function Game:things_at(x, y)
    return utils.filter(
        self.things,
        function(el)
            return el.map_ID == self.cur_map_ID and el.x == x and el.y == y
        end
    )
end

function Game:get_blocker_at(x, y)
    return utils.find(
        self:things_at(x, y),
        function(el)
            return el:has("block-move")
        end
    )
end

function Game:cur_map()
    return self.maps[self.cur_map_ID]
end

function Game:change_map(map_ID)
    self.cur_map_ID = map_ID
end

function Game:player()
    return self.things.player
end

function Game:set_player(entity)
    entity.id = "player"
    self:add_entity(entity)
end

function Game:pause()
    self.engine:lock()
end

function Game:resume()
    self.engine:unlock()
end

return Game
