local Entity = require("class"):extend("Entity")
local counter = 1
local utils = require("utils")

function Entity:init(optParam)
    local opts = utils.copy(optParam)
    self.mixins = {}
    self.groups = {}
    self.name = opts.name or "no name"
    self.desc = opts.desc or "no desc"
    self.id = string.format("%s-%d", self.name, counter)
    if opts.tags then
        table.insert(opts.tags, self.id)
    else
        opts.tags = {self.id}
    end
    self.tags = opts.tags
    self.x = 0
    self.y = 0
    self.layer = opts.layer or 2
    if type(opts.glyph) == "string" and #opts.glyph == 1 then
        self.glyph = utf8.codepoint(opts.glyph)
    elseif type(opts.glyph) == "number" then
        self.glyph = opts.glyph
    else
        self.glyph = utf8.codepoint("@")
    end
    for _, mixin in pairs(opts.mixins or {}) do
        for k, v in pairs(mixin) do
            if k == "name" then
                self.mixins[v] = true
            elseif k == "group" then
                self.groups[v] = true
            elseif not self[k] then
                self[k] = v
            end
        end
        if mixin.init then
            mixin.init(self, opts)
        end
    end
    for _, mixin in pairs(opts.mixins or {}) do
        if mixin.finisher then
            mixin.finisher(self, opts)
        end
    end
end

function Entity:has(mixin)
    return self.mixins[mixin] or self.groups[mixin]
end

return Entity
