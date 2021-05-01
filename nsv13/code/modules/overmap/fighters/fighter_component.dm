/obj/item/fighter_component
	name = "Fighter Component"
	desc = "It doesn't really do a whole lot"
	icon = 'nsv13/icons/obj/fighter_components.dmi'
	w_class = WEIGHT_CLASS_GIGANTIC
	//Thanks to comxy on Discord for these lovely tiered sprites o7
	var/tier = 1 //Icon states are formatted as: armour_tier1 and so on.
	var/slot = null //Change me!
	var/weight = 0 //Some more advanced modules will weigh your fighter down some.
	var/power_usage = 0 //Does this module require power to process()?
	var/fire_mode = null //Used if this is a weapon style hardpoint
	var/active = TRUE

/obj/item/fighter_component/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click it to unload its contents.</span>"

/obj/item/fighter_component/proc/toggle()
	active = !active

/obj/item/fighter_component/proc/dump_contents()
	if(!contents?.len)
		return FALSE
	. = list()
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(loc))
		. += AM

/obj/item/fighter_component/proc/get_ammo()
	return FALSE

/obj/item/fighter_component/proc/get_max_ammo()
	return FALSE

/obj/item/fighter_component/Initialize()
	.=..()
	AddComponent(/datum/component/twohanded/required) //These all require two hands to pick up
	if(tier)
		icon_state = icon_state+"_tier[tier]"

//Overload this method to apply stat benefits based on your module.
/obj/item/fighter_component/proc/on_install(obj/structure/overmap/target)
	forceMove(target)
	apply_drag(target)
	playsound(target, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)
	target.visible_message("<span class='notice'>[src] mounts onto [target]")
	return TRUE

//Allows you to jumpstart a fighter with an inducer.
/obj/structure/overmap/fighter/get_cell()
	return loadout.get_slot(HARDPOINT_SLOT_BATTERY)

/obj/item/fighter_component/proc/powered()
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F) || !active)
		return FALSE
	var/obj/item/fighter_component/battery/B = F.loadout.get_slot(HARDPOINT_SLOT_BATTERY)
	return B?.use_power(power_usage)

/obj/item/fighter_component/process()
	if(!powered())
		return FALSE
	return TRUE

//Used for weapon style hardpoints
/obj/item/fighter_component/proc/fire(obj/structure/overmap/target)
	return FALSE

/*
If you need your hardpoint to be loaded with things by clicking the fighter
*/
/obj/item/fighter_component/proc/load(obj/structure/overmap/target, atom/movable/AM)
	return FALSE

/obj/item/fighter_component/proc/apply_drag(obj/structure/overmap/target)
	if(!weight)
		return FALSE
	target.speed_limit -= weight
	target.speed_limit = (target.speed_limit > 0) ? target.speed_limit : 0
	target.forward_maxthrust -= weight
	target.forward_maxthrust = (target.forward_maxthrust > 0) ? target.forward_maxthrust : 0
	target.backward_maxthrust -= weight
	target.backward_maxthrust = (target.backward_maxthrust > 0) ? target.backward_maxthrust : 0
	target.side_maxthrust -= 0.25*weight
	target.side_maxthrust = (target.side_maxthrust > 0) ? target.side_maxthrust : 0
	target.max_angular_acceleration -= weight*10
	target.max_angular_acceleration = (target.max_angular_acceleration > 0) ? target.max_angular_acceleration : 0

/*
Remove from(), a proc that forcemoves a component onto the target's tile and removes the weight penalties caused by the specific component. Usually used for removal, but doesn't actually check if it was on the target, use with care.
args:
target: The overmap structure getting the component's weight penalties removed, aswell as the component being moved to its tile.
due_to_damage: If the removal was caused voluntarily (FALSE), or if it was caused by external sources / damage (TRUE); generally influences some specifics of removal on some components.
*/
/obj/item/fighter_component/proc/remove_from(obj/structure/overmap/target, due_to_damage)
	forceMove(get_turf(target))
	if(!weight)
		return TRUE
	for(var/atom/movable/AM in contents)
		AM.forceMove(get_turf(target))
	target.speed_limit += weight
	target.forward_maxthrust += weight
	target.backward_maxthrust += weight
	target.side_maxthrust += 0.25*weight
	target.max_angular_acceleration += weight*10
	return TRUE
