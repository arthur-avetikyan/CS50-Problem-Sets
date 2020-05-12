--[[
    Contains tile data and necessary code for rendering a tile map to the
    screen.
]]

require 'Util'

Map = Class {}

TILE_EMPTY = -1

GROUND = 5
UNDERGROUND = 6

BLOCK_ONE = 1
BLOCK_TWO = 2
BLOCK_THREE = 3
BLOCK_FOUR = 4

GOAL_TOP = 7
GOAL_BOT = 8

BLOCK_IDS = {BLOCK_ONE, BLOCK_TWO, BLOCK_THREE, BLOCK_FOUR}

-- a speed to multiply delta time to scroll map; smooth value
local SCROLL_SPEED = 62

local TILE_WIDTH = 48
local TILE_HEIGHT = 16

-- constructor for our map object
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/map.png')
    self.sprites = generateQuads(self.spritesheet, TILE_WIDTH, TILE_HEIGHT)
    self.music = love.audio.newSource('sounds/music.wav', 'static')

    self.tileWidth = TILE_WIDTH
    self.tileHeight = TILE_HEIGHT
    self.mapWidth = 9
    self.mapHeight = 100
    self.tiles = {}

    -- applies positive Y influence on anything affected
    self.gravity = 15

    -- associate player with map
    self.player = Player(self)

    -- camera offsets
    self.camX = 0
    self.camY = -3

    -- cache width and height of map in pixels
    self.mapWidthPixels = self.mapWidth * self.tileWidth
    self.mapHeightPixels = self.mapHeight * self.tileHeight

    -- first, fill map with empty tiles
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do

            -- support for multiple sheets per tile; storing tiles as tables 
            self:setTile(x, y, TILE_EMPTY)
        end
    end

    for x = 1, self.mapWidth do
        for y = self.mapHeight - 4, self.mapHeight do
            if y == self.mapHeight - 4 then
                self:setTile(x, y, GROUND)
            else
                self:setTile(x, y, UNDERGROUND)
            end
        end
    end

    local y = self.mapHeight - 7
    local numberOfBlocks = 0
    while y > 5 do
        if y > 75 then
            numberOfBlocks = 4
        elseif y > 50 then
            numberOfBlocks = 3
        elseif y > 25 then
            numberOfBlocks = 2
        else
            numberOfBlocks = 1
        end
        for z = 0, numberOfBlocks do
            local tileID = BLOCK_IDS[math.random(4)]
            local x = math.random(self.mapWidth)
            self:setTile(x, y, tileID)
        end
        y = y - 3
    end

    local goalX = math.random(self.mapWidth - 1)
    self:setTile(goalX, 4, BLOCK_IDS[math.random(4)])
    self:setTile(goalX, 3, GOAL_BOT)
    self:setTile(goalX, 2, GOAL_TOP)

    -- start the background music
    self.music:setLooping(true)
    self.music:play()
end

-- return whether a given tile is collidable
function Map:collides(tile)
    -- define our collidable tiles
    local collidables = {
        GROUND, UNDERGROUND, BLOCK_ONE, BLOCK_TWO, BLOCK_THREE, BLOCK_FOUR
    }

    -- iterate and return true if our tile type matches
    for _, v in ipairs(collidables) do if tile.id == v then return true end end

    return false
end

function Map:win(goal)
    local goals = {GOAL_BOT, GOAL_TOP}
    for _, v in pairs(goals) do if goal.id == v then return true end end
    return false
end

-- function to update camera offset with delta time
function Map:update(dt)
    self.player:update(dt)

    self.camY = self.player.y - VIRTUAL_HEIGHT / 2 - 35
end

-- gets the tile type at a given pixel coordinate
function Map:tileAt(x, y)
    return {
        x = math.floor(x / self.tileWidth) + 1,
        y = math.floor(y / self.tileHeight) + 1,
        id = self:getTile(math.floor(x / self.tileWidth) + 1,
                          math.floor(y / self.tileHeight) + 1)
    }
end

-- returns an integer value for the tile at a given x-y coordinate
function Map:getTile(x, y) return self.tiles[(y - 1) * self.mapWidth + x] end

-- sets a tile at a given x-y coordinate to an integer value
function Map:setTile(x, y, id) self.tiles[(y - 1) * self.mapWidth + x] = id end

-- renders our map to the screen, to be called by main's render
function Map:render()
    if self.player.won then
        love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 38))
        love.graphics.print('Victory', VIRTUAL_WIDTH / 3, self.player.y - 30, 0,
                            1, 1)
    else
        for y = 1, self.mapHeight do
            for x = 1, self.mapWidth do
                local tile = self:getTile(x, y)
                if tile ~= TILE_EMPTY then
                    love.graphics.draw(self.spritesheet, self.sprites[tile],
                                       (x - 1) * self.tileWidth,
                                       (y - 1) * self.tileHeight)
                end
            end
        end

        self.player:render()
    end
end
