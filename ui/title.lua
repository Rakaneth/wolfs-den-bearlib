local Title = require('ui.ui'):extend("Title")

function Title:init()
    self.name = "title"
end

function Title:render(term)
    term.print(10, 10, "This is the title screen.")
end

return Title
