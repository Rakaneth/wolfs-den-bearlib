local BaseClass = require("class")
local UI = BaseClass:extend("UI")

function UI:init()
    self.name = "No name"
end

function UI:enter()
    local temp = "Entered %s screen"
    print(temp:format(self.name))
end

function UI:exit()
    local temp = "Exited %s screen"
    print(temp:format(self.name))
end

function UI:render(term)
    term.print(0, 0, "Please override the render method in this UI.")
end

return UI
