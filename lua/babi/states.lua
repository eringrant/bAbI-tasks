-- Copyright (c) 2015-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.

-- Adapted from the original by Erin Grant (eringrant@berkeley.edu), 2016.

-- This source code defines states in the simuated world.
-- State should define three methods:
--     is_valid: Check whether the state is valid to execute.
--     perform: Change the state of the world to be consistent with this state.
--     update_knowledge: If the containing clause is True, update the state of 
--         agent's knowledge as a result of this state change.

-- An state change is only applied if the clause is true, but is_valid and 
-- update_knowledge will be called regardless though and should take the truth 
-- value into account.

local Set = require 'pl.Set'
local List = require 'pl.List'
local tablex = require 'pl.tablex'

local babi = require 'babi._env'

local DIRECTIONS = Set{'n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw', 'u', 'd'}
local NUMERIC_RELATIONS = {'size', 'x', 'y', 'z'}
local OPPOSITE_DIRECTIONS = {n='s', ne='sw', e='w', se='nw', s='n',
                             sw='ne', w='e', nw='se', u='d', d='u'}


do
    local State = torch.class('babi.State', babi)

    function State:__tostring()
        return torch.type(self)
    end
end

do
    local Occupy = torch.class('babi.Occupy', 'babi.State', babi)

    function Occupy:is_valid(world, actor, location)
        return true
    end

    function Occupy:perform(world, actor, location)
        actor.is_in = location
        a0.carry = a0.carry + a1.size
    end

    function Occupy:update_knowledge(world, knowledge, clause, a0, a1)
	-- TODO
    end
end

return {
    occupy=babi.Occupy,
}
