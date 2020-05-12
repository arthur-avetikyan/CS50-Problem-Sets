# Climb High

A game using Lua with LÖVE, player must climb to the top of the map using spacebar and arrow keys to control, and reach to the doorway, which is the victory point.

## Usage
Use spacebar for jumping.
Use left arrow key to move left.
Use right arrow key to move right.

## main.lua:
Application entry point which is executable with Love2D framework

## Map.lua:
Contains tile data and necessary code for rendering a tile map to the screen.

## Player.lua:
Represents our player in the game, with its own sprite.

## Animation.lua:
Holds a collection of frames that switch depending on how much time has passed.

## Util.lua:
Stores utility functions used by our game engine.

## Preexisting libraries used in the game.
class.lua _ Copyright (c) 2010-2013 Matthias Richter
push.lua _ Copyright (c) 2018 Ulysse Ramage