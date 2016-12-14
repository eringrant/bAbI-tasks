-- Copyright (c) 2015-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree. An additional grant
-- of patent rights can be found in the PATENTS file in the same directory.

local List = require 'pl.List'
local Set = require 'pl.Set'

local babi = require 'babi'
local actions = require 'babi.actions'
local utilities = require 'babi.utilities'

local BeliefsActionsBeliefs = torch.class('babi.BeliefsActionsBeliefs', 'babi.Task', babi)

function BeliefsActionsBeliefs:new_world()
    local world = babi.World()
    world:load((BABI_HOME or '') .. 'tasks/worlds/world_basic.txt')
    return world
end

function BeliefsActionsBeliefs:generate_story(world, knowledge, story)

    local actors = world:get_actors()
    local locations = world:get_locations()
    local objects = world:get_objects()
    local containers = world:get_containers()
    
    local num_questions = 0

    while num_questions < 5 do

        local clauses = List()

        local random_actors = utilities.choice(actors, 2)
	local random_location = locations[math.random(#locations)]
	local random_object = objects[math.random(#objects)]
        local random_containers = utilities.choice(containers, 2)

	-- whether or not the person will maintain a false belief
	local enter_exit = ({true, false})[math.random(2)]

        -- person A drops the item in container X
        clauses:append(
            babi.Clause(world, 
                        true, 
                        random_actors[1],
                        actions.place, 
                        random_object,
                        random_containers[1]
            )
        )

	if enter_exit then

            -- person A exits the location
            clauses:append(
                babi.Clause(world, 
                            true, 
                            random_actors[1],
                            actions.exit, 
                            random_location
                )
            )

	end

        -- person B moves the item from container X to container Y
        clauses:append(
            babi.Clause(
                world, 
                true, 
                random_actors[2],
                actions.transport, 
                random_object,
                random_containers[1],
                random_containers[2]
            )
        )

	if enter_exit then

            -- person A re-enters the location
            clauses:append(
                babi.Clause(
                    world, 
                    true, 
                    random_actors[1],
                    actions.enter, 
                    random_location
                )
            )

	end

        -- Update the state of the world
        for i, clause in pairs(clauses) do
            clause:perform()
        end
        story:extend(clauses)

	if enter_exit then
            -- question: where does person A seach for the item?
            story:append(babi.Question(
                'eval',
                babi.Clause(
                    world,  
                    true,
                    random_actors[1],
                    actions.search,
                    random_object,
                    random_containers[1]
                ),
                Set{clauses}
            ))
	else
            -- question: where does person A seach for the item?
            story:append(babi.Question(
                'eval',
                babi.Clause(
                    world,  
                    true,
                    random_actors[1],
                    actions.search,
                    random_object,
                    random_containers[2]
                ),
                Set{clauses}
            ))
	end

        num_questions = num_questions + 1

    end
    return story, knowledge
end

return BeliefsActionsBeliefs
