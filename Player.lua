--[[
    Represents our player in the game, with its own sprite.
]] 

Player = Class {}

local WALKING_SPEED = 100
local JUMP_VELOCITY = 300

local CHAR_WIDTH = 16
local CHAR_HEIGHT = 18

function Player:init(map)

    self.x = 0
    self.y = 0
    self.width = CHAR_WIDTH
    self.height = CHAR_HEIGHT

    -- offset from top left to center to support sprite flipping
    self.xOffset = 8
    self.yOffset = 10

    -- reference to map for checking tiles
    self.map = map
    self.texture = love.graphics.newImage('graphics/orc.png')

    self.won = false

    -- sound effects
    self.sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['coin'] = love.audio.newSource('sounds/coin.wav', 'static')
    }

    -- animation frames
    self.frames = {}

    -- current animation frame
    self.currentFrame = nil

    -- used to determine behavior and animations
    self.state = 'idle'

    -- determines sprite flipping
    self.direction = 'left'

    -- x and y velocity
    self.dx = 0
    self.dy = 0

    -- position on top of map tiles
    self.y = map.tileHeight * (map.mapHeight - 5) - self.height
    self.x = map.tileWidth * 2

    -- initialize all player animations
    self.animations = {
        ['idle'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(CHAR_WIDTH, CHAR_HEIGHT * 2, CHAR_WIDTH,
                                      CHAR_HEIGHT, self.texture:getDimensions())
            }
        }),
        ['walking'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(CHAR_WIDTH, CHAR_HEIGHT, CHAR_WIDTH,
                                      CHAR_HEIGHT, self.texture:getDimensions()),
                love.graphics.newQuad(0, CHAR_HEIGHT, CHAR_WIDTH, 20,
                                      self.texture:getDimensions()),
                love.graphics.newQuad(CHAR_WIDTH * 2, CHAR_HEIGHT, CHAR_WIDTH,
                                      20, self.texture:getDimensions()),
                love.graphics.newQuad(CHAR_WIDTH, CHAR_HEIGHT, CHAR_WIDTH, 20,
                                      self.texture:getDimensions())
            },
            interval = 0.15
        }),
        ['jumping'] = Animation({
            texture = self.texture,
            frames = {
                love.graphics.newQuad(CHAR_WIDTH * 3, 0, CHAR_WIDTH,
                                      CHAR_HEIGHT, self.texture:getDimensions())
            }
        })
    }

    -- initialize animation and current frame we should render
    self.animation = self.animations['idle']
    self.currentFrame = self.animation:getCurrentFrame()

    -- behavior map we can call based on player state
    self.behaviors = {
        ['idle'] = function(dt)

            -- add spacebar functionality to trigger jump state
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('left') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            elseif love.keyboard.isDown('right') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
                self.state = 'walking'
                self.animations['walking']:restart()
                self.animation = self.animations['walking']
            else
                self.dx = 0
            end
        end,
        ['walking'] = function(dt)

            -- keep track of input to switch movement while walking, or reset
            -- to idle if we're not moving
            if love.keyboard.wasPressed('space') then
                self.dy = -JUMP_VELOCITY
                self.state = 'jumping'
                self.animation = self.animations['jumping']
                self.sounds['jump']:play()
            elseif love.keyboard.isDown('left') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
            else
                self.dx = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
            end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()

            -- check if there's a tile directly beneath us
            if not self.map:collides(self.map:tileAt(self.x,
                                                     self.y + self.height)) and
                not self.map:collides(self.map:tileAt(self.x + self.width - 1,
                                                      self.y + self.height)) then

                -- if so, reset velocity and position and change state
                self.state = 'jumping'
                self.animation = self.animations['jumping']
            end
        end,
        ['jumping'] = function(dt)
            -- break if we go below the surface
            if self.y > map.tileHeight * map.mapHeight then return end

            if love.keyboard.isDown('left') then
                self.direction = 'left'
                self.dx = -WALKING_SPEED
            elseif love.keyboard.isDown('right') then
                self.direction = 'right'
                self.dx = WALKING_SPEED
            end

            -- apply map's gravity before y velocity
            self.dy = self.dy + self.map.gravity

            -- check if there's a tile directly beneath us
            if self.map:collides(self.map:tileAt(self.x, self.y + self.height)) or
                self.map:collides(self.map:tileAt(self.x + self.width - 1,
                                                  self.y + self.height)) then

                -- if so, reset velocity and position and change state
                self.dy = 0
                self.state = 'idle'
                self.animation = self.animations['idle']
                self.y = (self.map:tileAt(self.x, self.y + self.height).y - 1) *
                             self.map.tileHeight - self.height
            end

            -- if self.dy >= 0 then self:checkBottomObjectCollision() end

            -- check for collisions moving left and right
            self:checkRightCollision()
            self:checkLeftCollision()
        end
    }
end

function Player:update(dt)
    if not self.won then
        self.behaviors[self.state](dt)
        self.animation:update(dt)
        self.currentFrame = self.animation:getCurrentFrame()
        self.x = self.x + self.dx * dt

        self:calculateJumps()
        self:checkVictory()

        -- apply velocity
        self.y = self.y + self.dy * dt
    end
end

-- jumping and block hitting logic
function Player:calculateJumps()

    -- if we have negative y velocity (jumping), check if we collide
    -- with any blocks above us
    if self.dy < 0 then
        if self.map:tileAt(self.x, self.y).id ~= TILE_EMPTY or
            self.map:tileAt(self.x + self.width - 1, self.y).id ~= TILE_EMPTY then
            -- reset y velocity
            self.dy = 0

            self.sounds['coin']:play()

        end
    end
end

-- checks two tiles to our left to see if a collision occurred
function Player:checkLeftCollision()
    if self.dx < 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x - 1, self.y)) or
            self.map:collides(self.map:tileAt(self.x - 1,
                                              self.y + self.height - 1)) then

            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = self.map:tileAt(self.x - 1, self.y).x * self.map.tileWidth
        end
    end
end

-- checks two tiles to our right to see if a collision occurred
function Player:checkRightCollision()
    if self.dx > 0 then
        -- check if there's a tile directly beneath us
        if self.map:collides(self.map:tileAt(self.x + self.width, self.y)) or
            self.map:collides(self.map:tileAt(self.x + self.width,
                                              self.y + self.height - 1)) then

            -- if so, reset velocity and position and change state
            self.dx = 0
            self.x = (self.map:tileAt(self.x + self.width, self.y).x - 1) *
                         self.map.tileWidth - self.width
        end
    end
end

function Player:checkVictory()
    if self.map:win(self.map:tileAt(self.x + self.width, self.y)) or
        self.map:win(self.map:tileAt(self.x + self.width,
                                     self.y + self.height - 1)) or
        self.map:win(self.map:tileAt(self.x - 1, self.y)) or
        self.map:win(self.map:tileAt(self.x - 1, self.y + self.height - 1)) then
        self.won = true
    end
end

function Player:render()
    local scaleX

    -- set negative x scale factor if facing left, which will flip the sprite
    -- when applied
    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    -- draw sprite with scale factor and offsets
    love.graphics.draw(self.texture, self.currentFrame,
                       math.floor(self.x + self.xOffset),
                       math.floor(self.y + self.yOffset), 0, scaleX, 1,
                       self.xOffset, self.yOffset)
end
