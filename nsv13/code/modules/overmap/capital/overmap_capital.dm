
/obj/structure/overmap/capital_ship
	name = "capital ship"
	desc = "A generic unbranded capital ship. It has \'Made in space China\' printed on the back"
	icon = 'nsv13/icons/overmap/default.dmi'
	icon_state = "default"
	faction = "nanotrasen"
	var/datum/capital_ship_data/capital_ship_data
	role = INSTANCED_MIDROUND_SHIP

/obj/structure/overmap/capital_ship/Destroy()
	QDEL_NULL(capital_ship_data)
	. = ..()

//SYNDICATE

/obj/structure/overmap/capital_ship/syndicate
	name = "syndicate ship"
	desc = "A syndicate owned space faring vessel, it's painted with an ominous black and red motif."
	icon = 'nsv13/icons/overmap/default.dmi'
	icon_state = "default"
	faction = "syndicate"

/obj/structure/overmap/capital_ship/syndicate/hulk
	name = "SSV Hulk"
	icon = 'nsv13/icons/overmap/syndicate/syn_patrol_cruiser.dmi'
	icon_state = "patrol_cruiser"
	bound_width = 128
	bound_height = 256
	mass = MASS_LARGE
	sprite_size = 48
	pixel_z = -96
	pixel_w = -96
	obj_integrity = 750
	max_integrity = 750 //Max health
	integrity_failure = 750
	armor = list("overmap_light" = 70, "overmap_heavy" = 30)

/obj/structure/overmap/capital_ship/syndicate/mako_carrier
	name = "Sturgeon class escort carrier"
	icon_state = "mako_carrier"
	icon = 'nsv13/icons/overmap/new/syndicate/frigate.dmi'
	mass = MASS_SMALL
	bound_height = 64
	bound_width = 64
	sprite_size = 48
	damage_states = FALSE
	obj_integrity = 500
	max_integrity = 500
	integrity_failure = 500
	armor = list("overmap_light" = 50, "overmap_heavy" = 15)

/obj/structure/overmap/capital_ship/syndicate/mako_flak
	name = "Sturgeon class escort carrier"
	icon = 'nsv13/icons/overmap/new/syndicate/frigate.dmi'
	icon_state = "mako_flak"
	mass = MASS_SMALL
	bound_height = 64
	bound_width = 64
	sprite_size = 48
	damage_states = FALSE
	obj_integrity = 500
	max_integrity = 500
	integrity_failure = 500
	armor = list("overmap_light" = 50, "overmap_heavy" = 15)
