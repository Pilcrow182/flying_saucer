--[[

  Flying Saucer vehicle ('flying_saucer') mod for Minetest

  Copyright (C) 2018 Pilcrow182

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

]]--

flying_saucer = {}

flying_saucer.speed = minetest.settings:get("flying_saucer_speed") or 8
minetest.settings:set("flying_saucer_speed", flying_saucer.speed)

flying_saucer.passive_stop = minetest.settings:get_bool("flying_saucer_passive_stop", false)
minetest.settings:set_bool("flying_saucer_passive_stop", flying_saucer.passive_stop)

flying_saucer.storage = {}

local debug_msg = function(message)
	minetest.chat_send_all(message)
	minetest.log("action", message)
end

local activate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode enabled")
	flying_saucer.storage[name] = {}
	flying_saucer.storage[name].physics = player:get_physics_override()
	flying_saucer.storage[name].properties = player:get_properties()
	player:set_physics_override({speed = 2, jump = 0, gravity = 0, sneak = false, sneak_glitch = false})
	player:set_properties({
		visual_size = {x = 1, y = 1},
		visual = "mesh",
		mesh = "flying_saucer.x",
		textures = {"flying_saucer.png"},
		collisionbox = {-1.49,  0.00, -1.49,  1.49, 1.99,  1.49},
	})
	if pp and pp.disable then pp.disable[name] = true end
end

local deactivate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode disabled")
	player:set_physics_override(flying_saucer.storage[name].physics)
	player:set_properties(flying_saucer.storage[name].properties)
	flying_saucer.storage[name] = nil
	if pp and pp.disable then pp.disable[name] = nil end
end

local stopping_player = ""
minetest.register_entity("flying_saucer:stopper_entity", {
	textures = {"flying_saucer_stopper.png"},
	collisionbox = {0,0,0,0,0,0},
	is_visible = true,
	makes_footstep_sound = false,
	on_activate = function(self, staticdata)
		local player = minetest.get_player_by_name(stopping_player)
		if not player then return end
		flying_saucer.storage[stopping_player].state = "idle"
		player:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=-player:get_look_horizontal()*180/math.pi,z=0})
		minetest.after(0.2, function(obj) obj:remove() end, self.object)
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 0.2 then
		timer = 0
		for name,_ in pairs(flying_saucer.storage) do
			local player = minetest.get_player_by_name(name)
			if player then
				local ctrl = player:get_player_control()
				local velocity = player:get_player_velocity()
				local saucer_speed = tonumber(flying_saucer.speed)
				local physics = {speed = saucer_speed/4, jump = 0, gravity = 0, sneak = false, sneak_glitch = false}

				if (ctrl.jump or (flying_saucer.storage[name].state == "ascending" and velocity.y ~= 0)) and not (ctrl.sneak or ctrl.aux1) then
					flying_saucer.storage[name].state = "ascending"
					physics.gravity = -(saucer_speed-velocity.y)/saucer_speed
					player:set_physics_override(physics)
				elseif (ctrl.sneak or (flying_saucer.storage[name].state == "descending" and velocity.y ~= 0)) and not (ctrl.jump or ctrl.aux1) then
					flying_saucer.storage[name].state = "descending"
					physics.gravity =  (saucer_speed+velocity.y)/saucer_speed
					player:set_physics_override(physics)
				elseif ((ctrl.aux1 or flying_saucer.passive_stop or velocity.y == 0) and flying_saucer.storage[name].state ~= "idle") or not flying_saucer.storage[name].state then
					stopping_player = name
					minetest.add_entity(player:get_pos(), "flying_saucer:stopper_entity")
					player:set_physics_override(physics)
				end

				local state = flying_saucer.storage[name].state or "idle"
-- 				debug_msg("player '"..name.."' is "..state.." (physics="..minetest.pos_to_string({x=physics.speed, y=physics.jump,z=physics.gravity})..", velocity="..minetest.pos_to_string(velocity)..")...")
			end
		end
	end
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	if flying_saucer.storage[name].physics then
		deactivate_flying_saucer(player, name)
	end
end)

minetest.register_craftitem("flying_saucer:saucer", {
	description = "Flying saucer",
	inventory_image = "flying_saucer_saucer.png",
	wield_image = "flying_saucer_saucer.png",
	wield_scale = {x=1, y=1, z=1},
	liquids_pointable = false,
	on_use = function(itemstack, user, pointed_thing)
		local username = user:get_player_name()
		if flying_saucer.storage[username] then
			deactivate_flying_saucer(user, username)
		else
			activate_flying_saucer(user, username)
		end
	end
})

minetest.register_craft({
	output = "flying_saucer:saucer",
	recipe = {
		{"", "default:diamondblock", ""},
		{"default:copperblock", "default:steelblock","default:copperblock"},
	}
})

dofile(minetest.get_modpath(minetest.get_current_modname()).."/compat.lua")
