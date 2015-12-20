-- need to figure out how to not use hardcoded values
function loadSidebar()
    sb = {}
    sb.x = 64 * 9
    sb.y = 0
    sb.w = 64 * 3
    sb.h = 64 * 9
end

function drawSidebar()
    love.graphics.setColor(139,69,19,255)
    love.graphics.rectangle("fill", sb.x, sb.y, sb.w, sb.h)
    love.graphics.setColor(255,255,255,255)
end