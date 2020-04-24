PlayerCarryIdleState = Class{__includes = EntityIdleState}

function PlayerCarryIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.entity:changeAnimation('carry-idle-' .. self.entity.direction)
end

function PlayerCarryIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerCarryIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carry')
    end

    if love.keyboard.wasPressed('space') then
        self.dungeon.currentRoom.projectile:fire()
        self.entity:changeState('idle')
    end
end