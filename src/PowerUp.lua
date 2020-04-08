PowerUp = Class{}

local POWERUP_SPEED = 50

function PowerUp:init(type, x, y)
    self.type = type

    self.width = 16
    self.height = 16

    self.x = x
    self.y = y

    self.isPowering = false
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        
        return false
    end 
    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:update(dt)
    self.y = self.y + POWERUP_SPEED * dt
end

function PowerUp:render()
    if self.isPowering == false then
        love.graphics.draw(gTextures['main'], gFrames['powerUps'][self.type], self.x, self.y)
    end    
end
