local beholder = require("lib.beholder")
local terminal = require("BearLibTerminal")
local UIStack = require("ui.uistack")
local Main = require("ui.mainscreen")

beholder.observe(
    "title",
    function()
        UIStack:pop()
        UIStack:push(Main())
    end
)
