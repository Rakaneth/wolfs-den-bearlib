local block_move = {
    name = "block-move"
}

local block_sight = {
    name = "block-sight"
}

local inventory = {
    name = "inventory",
    inventory = {}
}

local player_actor = {
    name = "player-actor",
    group = "actor"
}

local vitals = {
    name = "vitals",
    alive = true,
    changeVit = function(self, amt)
        self.vit = self.vit + amt
    end,
    changeEdr = function(self, amt)
        self.edr = self.edr + amt
    end,
    maxVit = function(self)
        local stam = self.getStat and self:getStat("stam") or 10
        return stam * self.vitMult
    end,
    maxEdr = function(self)
        local stam = self.getStat and self:getStat("stam") or 10
        return stam * self.edrMult
    end,
    heal = function(self)
        self.vit = self:maxVit()
    end,
    restore = function(self)
        self.edr = self:maxEdr()
    end,
    init = function(self, opts)
        self.edrMult = opts.edrMult or 2
        self.vitMult = opts.vitMult or 1
    end,
    finisher = function(self)
        self:heal()
        self:restore()
    end
}

local move = {
    name = 'move',
    group = 'move',
    tryMoveBy = function(self, dx, dy)
        --TODO: moveby function
    end,
}

local digger = {
    name = 'digger',
    group = 'move',
    tryMoveBy = function(self, dx, dy)
        --TODO: moveby function (digger)
    end,
}

local stats = {
    name = 'stats',
    group = 'stats',
    getStat = function(stat)
        return self[stat] or 0
    end,
    init = function(self, opts)
        self.str = opts.str or 10
        self.stam = opts.stam or 10
        self.spd = opts.spd or 10
        self.skl = opts.skl or 10
        self.sag = opts.sag or 10
        self.smt = opts.smt or 10
    end
}

local equipper = {
    name = 'equipper',
    group = 'stats',
    getStat = function(stat)
        --TODO: implement equipper stats
    end,
    init = function(self, opts)
        self.str = opts.str or 10
        self.stam = opts.stam or 10
        self.spd = opts.spd or 10
        self.skl = opts.skl or 10
        self.sag = opts.sag or 10
        self.smt = opts.smt or 10
    end
}

return {
    block_move, 
    block_sight, 
    inventory, 
    player_actor, 
    vitals, 
    move, 
    digger, 
    stats,
    equipper
}
