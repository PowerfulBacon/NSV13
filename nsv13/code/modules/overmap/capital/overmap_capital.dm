
/obj/structure/overmap/capital_ship
	name = "capital ship"
	desc = "A generic unbranded capital ship. It has \'Made in space China\' printed on the back"
	icon = 'nsv13/icons/overmap/default.dmi'
	icon_state = "default"
	faction = "nanotrasen"
	var/datum/capital_ship_data/capital_ship_data

/obj/structure/overmap/capital_ship/Destroy()
	QDEL_NULL(capital_ship_data)
	. = ..()

/obj/structure/overmap/capital_ship/syndicate/pvp //Syndie PVP ship.
	name = "SSV Nebuchadnezzar"
	icon = 'nsv13/icons/overmap/syndicate/tuningfork.dmi'
	icon_state = "tuningfork"
	desc = "A highly modular cruiser setup which, despite its size, is capable of delivering devastating firepower."
	mass = MASS_MEDIUM
	sprite_size = 96
	damage_states = FALSE
	obj_integrity = 1000
	max_integrity = 1000
	integrity_failure = 1000
	ai_controlled = FALSE
	//collision_positions = list(new /datum/vector2d(-27,62), new /datum/vector2d(-30,52), new /datum/vector2d(-30,11), new /datum/vector2d(-32,-16), new /datum/vector2d(-30,-45), new /datum/vector2d(-24,-58), new /datum/vector2d(19,-60), new /datum/vector2d(33,-49), new /datum/vector2d(35,24), new /datum/vector2d(33,60))
	bound_width = 128
	bound_height = 128
	role = PVP_SHIP
	starting_system = "The Badlands" //Relatively safe start, fleets won't hotdrop you here.
	armor = list("overmap_light" = 70, "overmap_heavy" = 20)
