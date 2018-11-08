flying_saucer = {}

flying_saucer.speed = minetest.settings:get("flying_saucer_speed") or 8
minetest.settings:set("flying_saucer_speed", flying_saucer.speed)

flying_saucer.passive_stop = minetest.settings:get_bool("flying_saucer_passive_stop", false)
minetest.settings:set_bool("flying_saucer_passive_stop", flying_saucer.passive_stop)

flying_saucer.using_saucer = {}

flying_saucer.state = {}

flying_saucer.stored_properties = {}

local debug_msg = function(message)
	minetest.chat_send_all(message)
	minetest.log("action", message)
end

local activate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode enabled")
	flying_saucer.stored_properties[name] = player:get_properties()
	player:set_properties({
		visual_size = {x = 1, y = 1},
		visual = "mesh",
		mesh = "flying_saucer.x",
		textures = {"flying_saucer.png"},
		collisionbox = {-1.0,  0.0, -1.0,  1.0, 2.2,  1.0},
	})
	flying_saucer.using_saucer[name] = player:get_physics_override()
	player:set_physics_override({speed = 2, jump = 0, gravity = 0, sneak = false, sneak_glitch = false})
	if pp and pp.disable then pp.disable[name] = true end
end

local deactivate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode disabled")
	player:set_physics_override(flying_saucer.using_saucer[name])
	player:set_properties(flying_saucer.stored_properties[name])
	flying_saucer.using_saucer[name] = nil
	flying_saucer.stored_properties[name] = nil
	flying_saucer.state[name] = nil
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
		flying_saucer.state[stopping_player] = "idle"
		player:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=-player:get_look_horizontal()*180/math.pi,z=0})
		minetest.after(0.2, function(obj) obj:remove() end, self.object)
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 0.2 then
		timer = 0
		for name,_ in pairs(flying_saucer.using_saucer) do
			local player = minetest.get_player_by_name(name)
			if player then
				local ctrl = player:get_player_control()
				local velocity = player:get_player_velocity()
				local saucer_speed = tonumber(flying_saucer.speed)
				local physics = {speed = saucer_speed/4, jump = 0, gravity = 0, sneak = false, sneak_glitch = false}

				if (ctrl.jump or (flying_saucer.state[name] == "ascending" and velocity.y ~= 0)) and not (ctrl.sneak or ctrl.aux1) then
					flying_saucer.state[name] = "ascending"
					physics.gravity = -(saucer_speed-velocity.y)/saucer_speed
					player:set_physics_override(physics)
				elseif (ctrl.sneak or (flying_saucer.state[name] == "descending" and velocity.y ~= 0)) and not (ctrl.jump or ctrl.aux1) then
					flying_saucer.state[name] = "descending"
					physics.gravity =  (saucer_speed+velocity.y)/saucer_speed
					player:set_physics_override(physics)
				elseif ((ctrl.aux1 or flying_saucer.passive_stop or velocity.y == 0) and flying_saucer.state[name] ~= "idle") or not flying_saucer.state[name] then
					stopping_player = name
					minetest.add_entity(player:get_pos(), "flying_saucer:stopper_entity")
					player:set_physics_override(physics)
				end

				local state = flying_saucer.state[name] or "idle"
-- 				debug_msg("player '"..name.."' is "..state.." (physics="..minetest.pos_to_string({x=physics.speed, y=physics.jump,z=physics.gravity})..", velocity="..minetest.pos_to_string(velocity)..")...")
			end
		end
	end
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	if flying_saucer.using_saucer[name] then
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
		if flying_saucer.using_saucer[username] then
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
