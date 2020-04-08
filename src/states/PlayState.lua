--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = {
        params.ball
    } 
    self.level = params.level

    self.recoverPoints = 5000
    --to change---------------------------------------------------------------------------------------------------------------------
    self.resizePoints = 7000
    self.hitCount = 0
    --to change---------------------------------------------------------------------------------------------------------------------
    self.powerUpPoints = 8000
    self.keyUpPoints = 10000

    self.inPlayBrickCount = #self.bricks
    self.lockedExist = PlayState:checkLockBrick(self.bricks)

    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end  
    
    -- update positions based on velocity
    self.paddle:update(dt)

    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end
      
    if self.power ~= nil then
        self.power:update(dt)
    end

    if self.key ~= nil then
        self.key:update(dt)
    end

    for k, ball in pairs(self.balls) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy
    
            --
            -- tweak angle of bounce based on where it hits the paddle
            --
    
            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
    
            gSounds['paddle-hit']:play()
        end
    
        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do
    
            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then
                
                if brick.key == false then
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    self.hitCount = self.hitCount + (brick.tier * 200 + brick.color * 25)
        
                    -- trigger the brick's hit function, which removes it from play
                    self.inPlayBrickCount = brick:hit(self.inPlayBrickCount)

                elseif self.paddle.isPowered['keyUp'] == true then
                    -- add to score
                    self.score = self.score + 2000
                    self.hitCount = self.hitCount + 2000

                    -- trigger the brick's hit function, which removes it from play
                    self.inPlayBrickCount = brick:hit(self.inPlayBrickCount)
                end
    
                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)
    
                    -- multiply recover points by 2
                    self.recoverPoints = math.min(100000, self.recoverPoints * 2)                
    
                    -- play recover sound effect
                    gSounds['recover']:play()
                end
    
                -- Resize paddle if certain amount of bricks are hit in a row
                if self.hitCount > self.resizePoints and self.paddle.size < 4 then
                    self.paddle.size = self.paddle.size + 1
                    self.paddle.width = 32 * self.paddle.size
                    self.resizePoints = self.resizePoints * 2
                end
    
                -- Threeball power up generation
                if self.hitCount > self.powerUpPoints and self.power == nil then                    
                    self.power = PowerUp(1, ball.x, ball.y)
                    self.powerUpPoints = math.min(100000, self.powerUpPoints * 2)
                elseif self.power ~= nil and self.power.isPowering == false and self.power.y > VIRTUAL_HEIGHT then
                    self.power = PowerUp(1, ball.x, ball.y)
                    self.powerUpPoints = math.min(100000, self.powerUpPoints * 2)
                end

                -- Key power up generation
                if self.lockedExist then
                    if self.key == nil then
                        if self.hitCount > self.keyUpPoints then
                            self.key = PowerUp(2, ball.x, ball.y)
                            self.keyUpPoints = math.min(100000, self.keyUpPoints * 2)
                        elseif self.inPlayBrickCount == 1 then
                            self.key = PowerUp(2, ball.x, ball.y)
                        end
                    elseif self.key ~= nil then
                        if self.key.isPowering == false and self.key.y > VIRTUAL_HEIGHT then
                            self.key = PowerUp(2, ball.x, ball.y)
                            self.keyUpPoints = math.min(100000, self.keyUpPoints * 2)
                        elseif self.key.isPowering == false and self.inPlayBrickCount == 1 then
                            self.key = PowerUp(2, ball.x, ball.y)
                        end
                    end
                end
                    
                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()
    
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        ball = ball,
                        recoverPoints = self.recoverPoints
                    })
                end
    
                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --
    
                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end
    
                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end
    
                -- only allow colliding with one brick, for corners
                break
            end        
        end

         -- if ball goes below bounds, revert to serve state and decrease health
        if ball.y >= VIRTUAL_HEIGHT then
            if table.getn(self.balls) == 1 then
                self.health = self.health - 1
                self.paddle.size = self.paddle.size - 1 > 1 and self.paddle.size - 1 or 1
                self.paddle.width = 32 * self.paddle.size
                self.hitCount = 0
                self.resizePoints = 7000
                self.powerUpPoints = 8000
                self.paddle.isPowered['threeBall'] = false
                self.power.isPowering = false

                gSounds['hurt']:play()

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints
                    })
                end
            else
                table.remove(self.balls, k)
                if table.getn(self.balls) == 1 then
                    self.paddle.isPowered['threeBall'] = false
                    self.paddle.isPowered['keyUp'] = false                    
                    self.hitCount = 0
                    self.resizePoints = 7000
                    self.powerUpPoints = 8000
                    self.keyUpPoints = 10000
                    self.power = nil
                    self.key = nil
                end
            end
        end
    end    

    -- set power to the collided powerup
    if self.power ~= nil then
        if self.power:collides(self.paddle) then
            self.paddle.isPowered['threeBall'] = true
            self.power.isPowering = true
        end
    end     

    if self.key ~= nil then
        if self.key:collides(self.paddle) then
            self.paddle.isPowered['keyUp'] = true
            self.key.isPowering = true
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

     -- Power up to three active balls
     if self.paddle.isPowered['threeBall'] == true and table.getn(self.balls) == 1 then      
        table.insert(self.balls, Ball(math.random(7)))
        self.balls[2].x = self.paddle.x + (self.paddle.width / 2) - 4
        self.balls[2].y = self.paddle.y - 8
        self.balls[2].dx = math.random(-200, 200)
        self.balls[2].dy = math.random(-50, -60)

        table.insert(self.balls, Ball(math.random(7)))  
        self.balls[3].x = self.paddle.x + (self.paddle.width / 2) - 4
        self.balls[3].y = self.paddle.y - 8
        self.balls[3].dx = math.random(-200, 200)
        self.balls[3].dy = math.random(-50, -60)  
    end

end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()

    for k, ball in pairs(self.balls) do
        ball:render()
    end
    
    if self.power ~= nil then
        self.power:render()
    end

    if self.key ~= nil then
        self.key:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end

function PlayState:checkLockBrick(bricks)
    for k, brick in pairs(bricks) do
        if brick.key then
            return true
        end
    end
    return false
end