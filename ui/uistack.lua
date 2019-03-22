local UIStack = {
    uis = {}
}

function UIStack:push(...)
    local args = {...}
    for _, ui in ipairs(args) do
        if ui.enter then
            ui:enter()
        end
        table.insert(self.uis, ui)
    end
end

function UIStack:peek()
    return self.uis[#self.uis]
end

function UIStack:pop()
    local el = self.uis[#self.uis]
    if el.exit then
        el:exit()
    end
    table.remove(self.uis)
end

function UIStack:popall()
    while #self.uis > 0 do
        self:pop()
    end
end

return UIStack
