--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]] LevelMaker = Class {}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND

    local lockPosition = math.random(width - 50, width - 20)
    local flagPosition = width - 5
    local keySpawned = false

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do table.insert(tiles, {}) end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and x ~= lockPosition and x ~= flagPosition then
            for y = 7, height do
                table.insert(tiles[y],
                             Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y], Tile(x, y, tileID,
                                            y == 7 and topper or nil, tileset,
                                            topperset))
            end

            if x == lockPosition then
                local lock = GameObject {
                    texture = 'keys_and_locks',
                    x = (x - 1) * TILE_SIZE,
                    y = 3 * TILE_SIZE,
                    width = TILE_SIZE,
                    height = TILE_SIZE,

                    frame = LOCKS[math.random(4)],
                    collidable = true,
                    consumable = false,
                    solid = true,
                    isLock = true,

                    onCollide = function(player, object)
                        gSounds['empty-block']:play()
                    end,

                    onConsume = function(player, object)
                        if player.hasKey then

                            gSounds['pickup']:play()

                            player.score = player.score + 100
                            player.hasKey = false

                            local pole =
                                GameObject {
                                    texture = 'poles',
                                    x = (flagPosition - 1) * TILE_SIZE,
                                    y = 3 * TILE_SIZE,
                                    width = TILE_SIZE,
                                    height = 3 * TILE_SIZE,
                                    frame = math.random(#POLES),
                                    collidable = false,
                                    consumable = true,
                                    solid = false,
                                    isLock = false,

                                    onConsume = function(player, object)
                                        gSounds['powerup-reveal']:play()
                                        gStateMachine:change('play', {
                                            levelCount = player.levelCount + 1,
                                            score = player.score
                                        })
                                    end

                                }
                            table.insert(objects, pole)

                            local flag =
                                GameObject {
                                    texture = 'flags',
                                    x = ((flagPosition - 1) * TILE_SIZE) +
                                        TILE_SIZE - 6,
                                    y = 3 * TILE_SIZE + 4,
                                    width = TILE_SIZE,
                                    height = TILE_SIZE,
                                    frame = FLAGS[math.random(8)],
                                    collidable = false,
                                    consumable = true,
                                    solid = false,
                                    isLock = false,

                                    onConsume = function(player, object)
                                        gSounds['powerup-reveal']:play()
                                        gStateMachine:change('play', {
                                            levelCount = player.levelCount + 1,
                                            score = player.score
                                        })
                                    end
                                }

                            table.insert(objects, flag)
                        end
                    end
                }
                table.insert(objects, lock)
            elseif x ~= flagPosition then

                -- chance to generate a pillar
                if math.random(8) == 1 then
                    blockHeight = 2

                    -- chance to generate bush on pillar
                    if math.random(8) == 1 then
                        table.insert(objects, GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] +
                                (math.random(4) - 1) * 7
                        })
                    end

                    -- pillar tiles
                    tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                    tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                    tiles[7][x].topper = nil

                    -- chance to generate bushes
                elseif math.random(8) == 1 then
                    table.insert(objects, GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] +
                            (math.random(4) - 1) * 7,
                        collidable = false
                    })
                end

                -- chance to spawn a block
                if math.random(10) == 1 then
                    table.insert(objects, -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,
                        lock = false,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem =
                                        GameObject {
                                            texture = 'gems',
                                            x = (x - 1) * TILE_SIZE,
                                            y = (blockHeight - 1) * TILE_SIZE -
                                                4,
                                            width = 16,
                                            height = 16,
                                            frame = math.random(#GEMS),
                                            collidable = true,
                                            consumable = true,
                                            solid = false,
                                            isLock = false,

                                            -- gem has its own function to add to the player's score
                                            onConsume = function(player, object)
                                                gSounds['pickup']:play()
                                                player.score =
                                                    player.score + 100
                                            end
                                        }

                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {
                                            y = (blockHeight - 2) * TILE_SIZE
                                        }
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                    -- end
                                else
                                    if not keySpawned then
                                        local key =
                                            GameObject {
                                                texture = 'keys_and_locks',
                                                x = (x - 1) * TILE_SIZE,
                                                y = (blockHeight - 1) *
                                                    TILE_SIZE - 4,
                                                width = TILE_SIZE,
                                                height = TILE_SIZE,
                                                frame = math.random(#KEYS),
                                                collidable = true,
                                                consumable = true,
                                                solid = false,
                                                isLock = false,

                                                onConsume = function(player,
                                                                     object)

                                                    gSounds['pickup']:play()
                                                    player.score =
                                                        player.score + 100
                                                    player.hasKey = true

                                                    for k, object in
                                                        pairs(
                                                            player.level.objects) do
                                                        if object.isLock then
                                                            object.solid = false
                                                            object.consumable =
                                                                true
                                                            object.collidable =
                                                                false
                                                        end
                                                    end
                                                end
                                            }

                                        Timer.tween(0.1, {
                                            [key] = {
                                                y = (blockHeight - 2) *
                                                    TILE_SIZE
                                            }
                                        })
                                        gSounds['powerup-reveal']:play()

                                        table.insert(objects, key)

                                        keySpawned = true
                                    end
                                end
                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    })
                end
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end
