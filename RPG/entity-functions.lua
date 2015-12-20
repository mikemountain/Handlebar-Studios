function loadEntities()
    player = {}
    player.x = 64
    player.y = 64
    player.w = 32
    player.h = 64 * .75
    player.speed = 200
end

-- need to figure out how to limit the boundaries of the map without actually hardcoding it
function updateEntities(dt)
    if love.keyboard.isDown("left") then
        if player.x > 0 then
            player.x = player.x - player.speed * dt
        end
    elseif love.keyboard.isDown("right") then
        if player.x < 64 * 9 - player.w then
            player.x = player.x + player.speed * dt
        end
    end

    if love.keyboard.isDown("up") then
        if player.y > 0 then
            player.y = player.y - player.speed * dt
        end
    elseif love.keyboard.isDown("down") then
        if player.y < 64 * 9 - player.h then
            player.y = player.y + player.speed * dt
        end
    end
end

function drawEntities()
    love.graphics.setColor(0,255,0,255)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
    -- this resets the map colour ... remove this and everything turns green
    love.graphics.setColor(255,255,255,255)
end