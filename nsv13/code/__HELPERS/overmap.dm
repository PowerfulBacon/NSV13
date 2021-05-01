// IMPORTANT PROC FOR CAPITAL SHIPS
// WILL RETURN A VIRTUAL Z-LEVEL FOR CAPITAL SHIPS
// SO YOU CAN CHECK TO MAKE SURE PEOPLE ARE ON THE SAME SHIP
// If virtual_z_levels is set to true, mobs on the same z-level
// but on different capital ships will have a z-value returns that is
// >= 1000.
// For obvious reasons this should not be used for technical byond stuff
// like locate, but for checking comm levels it is great.
/atom/proc/get_z_level(virtual_z_levels = FALSE)
	if(!virtual_z_levels)
		return z
	if(SSmapping.level_has_any_trait(z, list(ZTRAIT_RESERVED)))
		var/datum/capital_ship_data/found_ship = get_capital_ship()
		if(found_ship)
			return found_ship.virtual_z_level
		else
			return z
	else
		return z

/atom/proc/get_overmap() //Helper proc to get the overmap ship representing a given area.
	RETURN_TYPE(/obj/structure/overmap)
	if(!z || loc == null)
		return FALSE
	for(var/datum/space_level/SL in SSmapping.z_list)
		if(SL.z_value == z)
			if(ZTRAIT_RESERVED in SL.traits)
				var/datum/capital_ship_data/found_ship = get_capital_ship()
				if(found_ship)
					return found_ship.linked_ship
				else
					return FALSE
			else
				return SL.linked_overmap
	return FALSE

/proc/shares_overmap(atom/source, atom/target)
	var/obj/structure/overmap/OM = source.get_overmap()
	var/obj/structure/overmap/S = target.get_overmap()
	if(OM == S)
		return TRUE
	else
		return FALSE

/**
Helper method to get what ship an observer belongs to for stuff like parallax.
*/

/mob/proc/find_overmap()
	var/obj/structure/overmap/OM = loc?.get_overmap() //Accounts for things like fighters and for being in nullspace because having no loc is bad.
	if(!OM) //We're on the overmap Z-level itself, thus we don't belong to any ship
		if(last_overmap)
			last_overmap.mobs_in_ship -= src
		return
	if(last_overmap)
		last_overmap.mobs_in_ship -= src
	last_overmap = OM
	OM.mobs_in_ship += src
