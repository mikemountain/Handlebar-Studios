
isAlive = 1
score = 0
mainFont = love.graphics.newFont(20);
lastTouch = "none"
startW = 100
startS = 200
pTime = 1000

function love.load()
    bg = love.graphics.newImage("bg.png")
    WindowWidth, WindowHeight = love.graphics.getDimensions()

    powerup = {}
    powerup.time = pTime -- ten seconds for the powerup?
    powerup.set = 0
    powerup.active = 0
    powerup.player = ""
    powerup.next = {}

    p1 = {} -- new table for the p1
    p1.x = WindowWidth / 2    -- x,y coordinates of the p1
    p1.y = WindowHeight - 10
    p1.width = startW
    p1.height = 10
    p1.speed = startS
    p1.score = 0

    p2 = {} -- new table for the p2
    p2.x = WindowWidth / 2    -- x,y coordinates of the p2
    p2.y = 0
    p2.width = startW
    p2.height = 10
    p2.speed = startS
    p2.score = 0

    pellet = {}
    pellet.width = 10
    pellet.height = 10
    pellet.speed = 100

    if love.math.random(2) == 1 then
        pellet.xDir = 1
    else
        pellet.xDir = -1
    end

    if love.math.random(2) == 1 then
        pellet.yDir = 1
    else
        pellet.yDir = -1
    end

    pellet.x = WindowWidth / 2
    pellet.y = WindowHeight / 2
end

function love.update(dt)
    -- powerup is "running"
    if isAlive == 1 then
        -- generate a powerup 1% of the time (may be too frequent?)
        if love.math.random(100) == 1 then
            generatePowerup()
        end

        -- if the pellet goes out of bounds
        if pellet.y < 0 or pellet.y > WindowHeight then

            -- decide who scored the point, add to their score
            if pellet.y < 0 then
                p1.score = p1.score + 1
            else
                p2.score = p2.score + 1
            end

            -- reset the pellet (this effectively hides it)
            pellet.x = WindowWidth
            pellet.y = WindowHeight / 2
            isAlive = 0
            pellet.speed = 0

            -- reset the computer
            p2.x = WindowWidth / 2 - p2.width / 2
            p2.y = 0

            -- reset powerups
            powerup.next = {}
            powerup.set = 0
        end

        -- move the pellet in whatever direction it was going
        pellet.y = pellet.y + pellet.speed * dt * pellet.yDir
        pellet.x = pellet.x + pellet.speed * dt * pellet.xDir

        -- bank it off the walls and speed it up
        if pellet.x <= 0 then
            pellet.xDir = -pellet.xDir
            pellet.speed = pellet.speed
        elseif pellet.x + pellet.width >= WindowWidth - pellet.width then
            pellet.xDir = -pellet.xDir
            pellet.speed = pellet.speed
        end

        -- bounce off paddles and SPEED IT UP YEUH
        if CheckCollision(pellet.x, pellet.y, pellet.width, pellet.height, p1.x, p1.y, p1.width, p1.height) then
            -- pellet.xDir = -pellet.xDir
            pellet.yDir = -pellet.yDir
            pellet.speed = pellet.speed + 25
            lastTouch = "p1"
        elseif CheckCollision(pellet.x, pellet.y, pellet.width, pellet.height, p2.x, p2.y, p2.width, p2.height) then
            -- pellet.xDir = -pellet.xDir
            pellet.yDir = -pellet.yDir
            pellet.speed = pellet.speed + 25
            lastTouch = "p2"
        end

        local remPowerup = {}

        -- check if someone hits a powerup
        for i,v in ipairs(powerup.next) do
            if CheckCollision(pellet.x, pellet.y, pellet.width, pellet.height, v.x, v.y, v.w, v.h) then
                if lastTouch == "p1" then
                    p1.width = p1.width * 2
                    v.player = "p1"
                    v.active = 1
                elseif lastTouch == "p2" then
                    p2.width = p2.width * 2
                    v.player = "p2"
                    v.active = 1
                end
                table.insert(remPowerup, i)
            end
        end

        if powerup.active == 1 then
            powerup.time = powerup.time - 1
            if powerup.time <= 0 then
                if powerup.player == "p1" then
                    p1.width = startW
                else
                    p2.width = startW
                end
                powerup.time = pTime
                powerup.active = 0
            end
        end

        for i,v in ipairs(remPowerup) do
            table.remove(powerup.next, v)
        end

        if love.keyboard.isDown("left") then
            if p1.x > 0 then
                p1.x = p1.x - p1.speed*dt
            end
        elseif love.keyboard.isDown("right") then
            if p1.x + p1.width < WindowWidth then
                p1.x = p1.x + p1.speed*dt
            end
        end

        if pellet.x + pellet.width / 2 <= p2.x + p2.width / 2 then
            if p2.x > 0 then
                p2.x = p2.x - p2.speed * dt
            end
        elseif pellet.x + pellet.width / 2 >= p2.x + p2.width / 2 then
            if p2.x + p2.width <= WindowWidth then
                p2.x = p2.x + p2.speed * dt
            end
        end
    end

    if isAlive == 0 and love.keyboard.isDown('r') then
        isAlive = 1
        p1.x = WindowWidth / 2    -- x,y coordinates of the p1
        p1.y = WindowHeight - 10
        p1.width = startW

        p2.x = WindowWidth / 2    -- x,y coordinates of the p2
        p2.y = 0
        p2.width = startW

        -- if score == 1 then
        --     p1.score = p1.score + 1
        -- elseif score == -1 then
        --     p2.score = p2.score + 1
        -- end

        pellet.speed = 100

        if love.math.random(2) == 1 then
            pellet.xDir = 1
        else
            pellet.xDir = -1
        end

        if love.math.random(2) == 1 then
            pellet.yDir = 1
        else
            pellet.yDir = -1
        end

        powerup.time = pTime

        pellet.x = WindowWidth / 2
        pellet.y = WindowHeight / 2
        score = 0
    end
end

function love.draw()

    -- background
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg)

    -- p1
    love.graphics.setColor(0,0,255,255)
    love.graphics.rectangle("fill", p1.x, p1.y, p1.width, p1.height)

    -- p2
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle("fill", p2.x, p2.y, p2.width, p2.height)

    -- pellet
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", pellet.x, pellet.y, pellet.width, pellet.height)

    love.graphics.print(powerup.time, WindowWidth / 2, WindowHeight / 2)

    for i,v in ipairs(powerup.next) do
        love.graphics.setColor(0,255,0,255)
        love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
    end


    if isAlive == 0 then
        love.graphics.setFont(mainFont)
        line = "Press 'R' to restart\nPlayer score: " .. p1.score .. "\nComputer score: " .. p2.score
        lw = mainFont:getWidth(line)
        lh = mainFont:getHeight(line)
        love.graphics.setColor(255,255,255,255)
        love.graphics.print(line, WindowWidth / 2 - lw / 2, WindowHeight / 2 - lh / 2)
    end

end

function generatePowerup()
    if powerup.set == 0 then
        local p = {}
        p.w = 25 * 4
        p.h = 25 * 4
        p.x = love.math.random(0, WindowWidth - p.w)
        p.y = love.math.random(0 + WindowHeight / 7, WindowHeight - WindowHeight / 7)
        powerup.set = 1
        table.insert(powerup.next, p)
    end
end

-- function love.keyreleased(key)
--     if (key == " ") then
--         start()
--     end
--     if (key == "x") then
--         blast()
--     end
-- end

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end