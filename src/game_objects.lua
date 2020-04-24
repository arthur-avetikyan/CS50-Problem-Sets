--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        visible = true,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = TILE_SIZE,
        height = TILE_SIZE,
        solid = true,
        visible = true,
        defaultState = 'unpicked',
        states = {
            ['unpicked'] = {
                frame = 14
            },
            ['picked'] = {
                frame = 14
            },
            ['flying'] = {
                frame = 14
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = TILE_SIZE,
        height = TILE_SIZE,
        solid = false,
        defaultState = 'unpicked',
        visible = true,
        states = {
            ['unpicked'] = {
                frame = 5
            },
            ['picked'] = {
                frame = 6
            }
        }
    }
}