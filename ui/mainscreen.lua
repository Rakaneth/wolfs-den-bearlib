local Main = require("ui.ui"):extend("MainScreen")

local SCREEN_W = 100
local SCREEN_H = 40
local MAP_X = 0
local MAP_Y = 0
local MAP_W = 60
local MAP_H = 30
local STAT_X = MAP_W
local STAT_Y = 0
local STAT_W = SCREEN_W - MAP_W
local STAT_H = MAP_H
local MSG_X = 0
local MSG_Y = MAP_H
local MSG_W = MAP_W // 2
local MSG_H = SCREEN_H - MAP_H
local SKL_X = MSG_W
local SKL_Y = MSG_Y
local SKL_W = MAP_W // 2
local SKL_H = MSG_H
local INFO_X = STAT_X
local INFO_Y = MSG_Y
local INFO_W = STAT_W
local INFO_H = MSG_H

function Main:init()
    self.name = "main"
end

function Main:render(term)
    self:renderMap(term)
    self:renderMsgs(term)
    self:renderSkls(term)
    self:renderInfo(term)
    self:renderStats(term)
end

function Main:renderMap(term)
    term.print(MAP_X, MAP_Y, "Map")
end

function Main:renderMsgs(term)
    term.print(MSG_X, MSG_Y, "Messages")
end

function Main:renderSkls(term)
    term.print(SKL_X, SKL_Y, "Skills")
end

function Main:renderInfo(term)
    term.print(INFO_X, INFO_Y, "Info")
end

function Main:renderStats(term)
    term.print(STAT_X, STAT_Y, "Stats")
end

return Main
