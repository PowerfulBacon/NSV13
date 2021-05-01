/*
 * Unlike the flagship, other capital ships do not get an entire Z-Level to themselves,
 * instead they get a portion of a z-level.
 * They can be handed out a lot more since they aren't as big and expensive as the flagships.
 * If you are super cool, could do something to let ghosts join multi ship fun.
 *
 * Capital ships can only be 1 Z-thick.
 */

GLOBAL_LIST_EMPTY(cached_capital_ship_maps)
GLOBAL_LIST_EMPTY(capital_ships)

/datum/capital_ship_data
	//DOES NOT INCLUDE THE 1 TURF BORDER
	//ACCOUNT THAT FOR TECHNICAL SHIT
	var/x
	var/y
	var/width
	var/height
	var/z_level
	var/virtual_z_level
	var/obj/structure/overmap/capital_ship/linked_ship

/datum/capital_ship_data/New()
	. = ..()
	var/static/current_ship_id = 1000
	virtual_z_level = current_ship_id++
	GLOB.capital_ships += src

/datum/capital_ship_data/Destroy(force, ...)
	GLOB.capital_ships -= src
	. = ..()

/datum/capital_ship_data/proc/return_turfs()
	return block(
		locate(x, y, z_level),
		locate(x + width, y + height, z_level)
	)

/atom/proc/get_capital_ship()
	for(var/datum/capital_ship_data/ship as() in GLOB.capital_ships)
		if(ship.z_level != z)
			continue
		if(x < ship.x || y < ship.y)
			continue
		if(x > ship.x + ship.width || y > ship.y + ship.height)
			continue
		return ship
	return null

/client/proc/instance_capital_ship() //Creates a verb for admins to open up the ui
	set name = "Instance Capital Ship"
	set desc = "Load a capital ship midround."
	set category = "Adminbus"

	if(IsAdminAdvancedProcCall())
		return FALSE

	var/list/choices = flist("_maps/capital_ships/")
	var/ship_file = input(usr, "What ship would you like to load?","Ship Instancing", null) as null|anything in choices
	if(!ship_file)
		return
	var/ship_datum = input(usr, "What overmap type would you like to give it?", "Ship Instancing", null) as null|anything in typesof(/obj/structure/overmap/capital_ship)
	if(!ship_datum)
		return
	var/turf/T = get_turf(mob)
	spawn_capital_ship(ship_file, ship_datum, SSmapping.level_has_any_trait(T.z, list(ZTRAIT_OVERMAP)) ? T : null)

	message_admins("[key_name_admin(usr)] spawned a capital ship.")
	log_admin("[key_name(usr)] spawned a capital ship.")

/proc/spawn_capital_ship(map_path, ship_path = /obj/structure/overmap/capital_ship, turf/overmap_spawn_location)
	//Check for dumbness
	if(!map_path)
		CRASH("Spawn_capital_ship called without a provided map path.")

	map_path = "_maps/capital_ships/[map_path]"

	//Check to make sure spawn position is valid
	if(!overmap_spawn_location)
		//Plop them on a random overmap level.
		var/list/overmap_levels = SSmapping.levels_by_trait(ZTRAIT_OVERMAP)
		if(!overmap_levels)
			CRASH("No overmap levels exist.")
		overmap_spawn_location = locate(round(world.maxx * 0.5, 1), round(world.maxy * 0.5, 1), pick(overmap_levels))

	//Parse the map file
	var/datum/parsed_map/parsed_map

	//Cache loaded files.
	if(GLOB.cached_capital_ship_maps[map_path])
		parsed_map = GLOB.cached_capital_ship_maps[map_path]
	else
		parsed_map = new(file(map_path))
		GLOB.cached_capital_ship_maps[map_path] = parsed_map

	//Map failed to load
	if(!parsed_map)
		CRASH("Capital ship failed to load. Map Path: [map_path]")

	//Get the map bounds
	var/list/bounds = parsed_map.bounds
	var/width = bounds[MAP_MAXX]
	var/height = bounds[MAP_MAXY]

	//Get the reservation
	//Get a 1 turf border so we can add no pass turfs to the edge.
	var/datum/turf_reservation/capital_ship_reservation = SSmapping.RequestBlockReservation(width + 2, height + 2)
	if(!capital_ship_reservation)
		CRASH("Capital ship failed to reserve space. Width: [width], Height: [height]")

	//Load the capital ship map
	var/reservation_x = capital_ship_reservation.bottom_left_coords[1] + 1
	var/reservation_y = capital_ship_reservation.bottom_left_coords[2] + 1
	var/reservation_z = capital_ship_reservation.bottom_left_coords[3]

	//Lets spawn something around the edge so people can leave the ship.
	for(var/turf/reserved_turf in block(locate(capital_ship_reservation.bottom_left_coords[1], capital_ship_reservation.bottom_left_coords[2], reservation_z), locate(capital_ship_reservation.top_right_coords[1], capital_ship_reservation.top_right_coords[2], reservation_z)))
		//Its a border turf.
		if(reserved_turf.x == capital_ship_reservation.bottom_left_coords[1] || reserved_turf.x == capital_ship_reservation.top_right_coords[1] || reserved_turf.y == capital_ship_reservation.bottom_left_coords[2] || reserved_turf.y == capital_ship_reservation.top_right_coords[2])
			reserved_turf.ChangeTurf(/turf/closed/indestructible/cordon)

	message_admins("Capital ship map loading...")

	//Create the capital ship
	var/datum/capital_ship_data/capital_ship = new
	capital_ship.x = reservation_x
	capital_ship.y = reservation_y
	capital_ship.z_level = reservation_z
	capital_ship.width = capital_ship_reservation.top_right_coords[1] - 1 - reservation_x
	capital_ship.height = capital_ship_reservation.top_right_coords[2] - 1 - reservation_y

	//Do the thing
	var/obj/structure/overmap/capital_ship/overmap_ship = new ship_path(overmap_spawn_location)
	overmap_ship.capital_ship_data = capital_ship

	capital_ship.linked_ship = overmap_ship

	//Load the map
	if(!parsed_map.load(reservation_x, reservation_y, reservation_z))
		//Goodbye my lover
		capital_ship_reservation.Release()
		//oh shit get it out of here
		qdel(overmap_ship)
		CRASH("Capital ship map failed to place.")

	//Repopulate areas
	repopulate_sorted_areas()

	//Init template bounds or something
	parsed_map.initTemplateBounds()

	//Log
	log_mapping("Capital ship [map_path] loaded successfully.")

	message_admins("Capital ship created and loaded.")
