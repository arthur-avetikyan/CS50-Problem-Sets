--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]] FIRE_SPEED = 50
DEST_MODIFIER = 4

Projectile = Class {}

function Projectile:init(player, object)
    self.object = object
    self.player = player

    self.fired = false

    self.destinationX = 0
    self.destinationY = 0

    self.fireSpeedX = 0
    self.fireSpeedY = 0

    self.reached = false
end

function Projectile:update(dt)
    if self.fired then
        self.object.x = self.object.x + self.fireSpeedX * dt
        self.object.y = self.object.y + self.fireSpeedY * dt

        if self.fireSpeedX ~= 0 then
            if self.fireSpeedX > 0 then
                if self.object.x >= self.destinationX or self.object.x +
                    self.object.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
                    self.fireSpeedX = 0
                    gSounds['hit-enemy']:stop()
                    gSounds['hit-enemy']:play()
                    self.reached = true
                end
            else
                if self.object.x <= self.destinationX or self.object.x <=
                    MAP_RENDER_OFFSET_X + TILE_SIZE then
                    self.fireSpeedX = 0
                    gSounds['hit-enemy']:stop()
                    gSounds['hit-enemy']:play()
                    self.reached = true
                end
            end
        end

        if self.fireSpeedY ~= 0 then
            if self.fireSpeedY > 0 then
                if self.object.y >= self.destinationY or self.object.y +
                    self.object.height >= VIRTUAL_HEIGHT -
                    (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) +
                    MAP_RENDER_OFFSET_Y - TILE_SIZE then
                    self.fireSpeedY = 0
                    gSounds['hit-enemy']:stop()
                    gSounds['hit-enemy']:play()
                    self.reached = true
                end
            else
                if self.object.y <= self.destinationY or self.object.y <=
                    MAP_RENDER_OFFSET_Y + TILE_SIZE - self.object.height / 2 then
                    self.fireSpeedY = 0
                    gSounds['hit-enemy']:stop()
                    gSounds['hit-enemy']:play()
                    self.reached = true
                end
            end
        end
    else
        self.object.x = self.player.x
        self.object.y = self.player.y - 8
    end
end

function Projectile:fire()
    gSounds['hit-enemy']:stop()
    gSounds['hit-enemy']:play()

    if self.player.direction == 'down' then
        self.destinationX = self.object.x
        self.destinationY = self.object.y + DEST_MODIFIER * TILE_SIZE
        self.fireSpeedY = FIRE_SPEED
    elseif self.player.direction == 'up' then
        self.destinationX = self.object.x
        self.destinationY = self.object.y - DEST_MODIFIER * TILE_SIZE
        self.fireSpeedY = -FIRE_SPEED
    elseif self.player.direction == 'left' then
        self.destinationX = self.object.x - DEST_MODIFIER * TILE_SIZE
        self.destinationY = self.object.y
        self.fireSpeedX = -FIRE_SPEED
    elseif self.player.direction == 'right' then
        self.destinationX = self.object.x + DEST_MODIFIER * TILE_SIZE
        self.destinationY = self.object.y
        self.fireSpeedX = FIRE_SPEED
    end
    self.fired = true
end

function Projectile:collides(target)
    return not (self.object.x + self.object.width < target.x or self.object.x >
               target.x + target.width or self.object.y + self.object.height <
               target.y or self.object.y > target.y + target.height)
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    self.object:render(adjacentOffsetX, adjacentOffsetY)
end
