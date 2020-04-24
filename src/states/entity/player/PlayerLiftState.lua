


PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)  

    self.player = player
    self.dungeon = dungeon

    self.player:changeAnimation('lift-' .. self.player.direction)

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0
end

function PlayerLiftState:enter(params)
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart lifting animation
    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)
    local projectile = self.dungeon.currentRoom.projectile

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('carry-idle')
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end