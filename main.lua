local terminal = require("BearLibTerminal")
local UIStack = require("ui.uistack")
local UI = require("ui.ui")
local Title = require("ui.title")
local ROT = require("lib.rotLove.src.rot")
local utils = require("utils")

function main()
    --init terminal
    terminal.open()

    --init uis
    local input
    UIStack:push(Title())
    terminal.refresh()

    --test utils
    local base = {
        word = "bird",
        num = 42,
        nested = {
            thing = "lol"
        },
        f = function()
            return "hello"
        end
    }

    local base_clone = utils.copy(base)
    local base_merge =
        utils.merge(
        base_clone,
        {
            word = "mutated",
            added = "added",
            nested = {
                other = "other"
            }
        }
    )
    base_clone.num = 44

    --game loop
    repeat
        terminal.clear()

        for _, ui in pairs(UIStack.uis) do
            ui:render(terminal)
        end
        --TODO: Key handling

        terminal.refresh()
        input = terminal.read()
        if input == terminal.TK_CLOSE then
            UIStack:popall()
        end
    until #UIStack.uis == 0

    --clean up
    terminal.close()
end

function err_handler(err)
    print("ERROR: ", err)
end

if not xpcall(main, err_handler) then
    terminal.close()
end
