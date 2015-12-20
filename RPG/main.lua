require 'map-functions'
require 'sidebar-functions'
require 'entity-functions'

map = '/maps/outdoors.lua'

function love.load()
    loadMap(map)
    loadSidebar()
    loadEntities()
end

function love.update(dt)
    updateEntities(dt)
end

function love.draw()
    drawMap()
    drawSidebar()
    drawEntities()
end