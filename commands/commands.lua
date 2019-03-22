local Commands = {}

function Commands.move_by(dx, dy)
    return function(entity)
        entity.x = entity.x + dx
        entity.y = entity.y + dy
        return math.min(1, 100 - entity.spd)
    end
end

function Commands.move_to(x, y)
    return function(entity)
        entity.x = x
        entity.y = y
        return 0
    end
end

function Commands.wait()
    return function(entity)
        return 100
    end
end

return Commands
