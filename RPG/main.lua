function love.load()
    local tileString =
        "abbbbbbbc\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "d       f\n" ..
        "ghhhhhhhi"

    local quadInfo = {
        { 'a',   0,   0 },  -- 1 = top left
        { 'b',  64,   0 },  -- 2 = top mid
        { 'c', 128,   0 },  -- 3 = top right
        { 'd',   0,  64 },  -- 4 = mid left
        { ' ',  64,  64 },  -- 5 = mid mid
        { 'f', 128,  64 },  -- 6 = mid right
        { 'g',   0, 128 },  -- 7 = bot left
        { 'h',  64, 128 },  -- 8 = bot mid
        { 'i', 128, 128 }   -- 9 = bot right
    }

    loadMap(64, 64, 'sprites.png', tileString, quadInfo)
end

function love.update(dt)
end

function love.draw()
    drawMap()
end

function loadMap(tileW, tileH, tilesetPath, tileString, quadInfo)
    TileW = tileW
    TileH = tileH
    Tileset = love.graphics.newImage(tilesetPath)

    local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

    Quads = {}
    for _,info in ipairs(quadInfo) do
        Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
    end

    TileTable = {}

    local width = #(tileString:match("[^\n]+"))

    for x = 1,width,1 do TileTable[x] = {} end

    local rowIndex,columnIndex = 1,1
    for row in tileString:gmatch("[^\n]+") do
        assert(#row == width, 'Map is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
        columnIndex = 1
        for character in row:gmatch(".") do
            TileTable[columnIndex][rowIndex] = character
            columnIndex = columnIndex + 1
        end
        rowIndex=rowIndex+1
    end
end

function drawMap()
    for columnIndex,column in ipairs(TileTable) do
        for rowIndex,char in ipairs(column) do
            local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
            love.graphics.draw(Tileset, Quads[char], x, y)
        end
    end
end