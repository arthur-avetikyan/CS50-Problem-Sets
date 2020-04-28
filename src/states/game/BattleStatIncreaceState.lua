BattleStatIncreaceState = Class {__includes = BaseState}

function BattleStatIncreaceState:init(battleState, pokemon, HPIncrease,
                                      attackIncrease, defenseIncrease,
                                      speedIncrease, onClose)
    self.battleState = battleState
    self.pokemon = pokemon
    self.onClose = onClose

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH / 2,
        y = 0,
        width = VIRTUAL_WIDTH / 2,
        height = VIRTUAL_HEIGHT - 64,
        hasCursor = false,
        items = {
            {
                text = "Health: " .. self.pokemon.HP .. " + " .. HPIncrease ..
                    " = " .. self.pokemon.HP + HPIncrease

            }, {
                text = "Attack: " .. self.pokemon.attack .. " + " ..
                    attackIncrease .. " = " .. self.pokemon.attack +
                    attackIncrease
            }, {
                text = "Defense: " .. self.pokemon.defense .. " + " ..
                    defenseIncrease .. " = " .. self.pokemon.defense +
                    defenseIncrease
            }, {
                text = "Speed: " .. self.pokemon.speed .. " + " .. speedIncrease ..
                    " = " .. self.pokemon.speed + speedIncrease
            }
        }
    }
end

function BattleStatIncreaceState:update(dt)
    self.battleMenu:update(dt)
end

function BattleStatIncreaceState:render() self.battleMenu:render() end
