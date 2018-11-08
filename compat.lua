if not minetest.get_modpath("helicopter") then
	minetest.register_alias("helicopter:heli", "flying_saucer:saucer")
end

if not minetest.get_modpath("ufos") then
	minetest.register_alias("ufos:ufo", "flying_saucer:saucer")
end
