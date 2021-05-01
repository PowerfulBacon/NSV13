//Utility modules.

/obj/item/fighter_component/primary/utility
	name = "No :)"
	slot = HARDPOINT_SLOT_UTILITY_PRIMARY

/obj/item/fighter_component/primary/utility/fire(obj/structure/overmap/target)
	return FALSE

/obj/item/fighter_component/primary/utility/hold
	name = "Cargo Hold"
	desc = "A cramped cargo hold for hauling light freight."
	icon_state = "hold"
	var/max_w_class = WEIGHT_CLASS_GIGANTIC
	var/max_freight = 5

/obj/item/fighter_component/primary/utility/hold/tier2
	name = "Expanded Cargo Hold"
	tier = 2
	max_freight = 10

/obj/item/fighter_component/primary/utility/hold/tier3
	name = "S0CC3RMUM Jumbo Sized Cargo Hold"
	desc ="Now with extra space for seating unlucky friends in the boot!"
	tier = 3
	max_freight = 20

/obj/item/fighter_component/primary/utility/hold/load(obj/structure/overmap/target, atom/movable/AM)
	if(contents && contents.len >= max_freight || isliving(AM) || istype(AM, /obj/item/fighter_component) || istype(AM, /obj/item/card/id) || istype(AM, /obj/item/pda) || istype(AM, /obj/structure/overmap)) //This just causess issues, trust me on this)
		return FALSE
	if((AM.move_resist > MOVE_FORCE_DEFAULT) || !AM.doMove(src))
		return //Can't put ultra heavy stuff in
	target.visible_message("[icon2html(src)] [AM] is loaded into the cargo hold")
	playsound(target, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)
	return TRUE

/obj/item/fighter_component/primary/utility/repairer
	name = "Air-to-air Repair Kit"
	desc = "A module which can use hull repair foam to repair other fighters in the air."
	icon_state = "repairer"
	accepted_ammo = /obj/structure/reagent_dispensers/foamtank/hull_repair_juice
	power_usage = 50
	fire_delay = 5 SECONDS
	var/datum/beam/current_beam = null
	var/next_repair = 0

/obj/item/fighter_component/primary/utility/repairer/get_ammo()
	return magazine?.reagents.total_volume

/obj/item/fighter_component/primary/utility/repairer/get_max_ammo()
	return magazine?.reagents.maximum_volume

/obj/item/fighter_component/primary/utility/repairer/tier2
	name = "Upgraded Air To Air Repair Kit"
	tier = 2
	fire_delay = 4 SECONDS

/obj/item/fighter_component/primary/utility/repairer/tier3
	name = "Super Air To Air Repair Kit"
	tier = 3
	fire_delay = 3 SECONDS

/obj/item/fighter_component/primary/utility/repairer/load(obj/structure/overmap/target, atom/movable/AM)
	if(!istype(AM, accepted_ammo))
		return FALSE
	magazine?.forceMove(get_turf(target))
	if(!SSmapping.level_trait(loc.z, ZTRAIT_BOARDABLE))
		qdel(magazine) //So bullets don't drop onto the overmap.
	AM.forceMove(src)
	magazine = AM
	playsound(target, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)
	return TRUE

/obj/item/fighter_component/primary/utility/repairer/process()
	if(!..())
		return FALSE
	var/obj/structure/overmap/fighter/us = loc
	if(!us || !istype(us) || us.fire_mode != fire_mode)
		qdel(current_beam)
		return FALSE
	var/obj/structure/overmap/them = us.autofire_target
	if(!them || !istype(them))
		qdel(current_beam)
		return FALSE
	var/obj/structure/reagent_dispensers/foamtank/hull_repair_juice/tank = magazine
	if(!tank || !istype(tank))
		qdel(current_beam)
		return FALSE
	if(world.time < next_repair)
		return FALSE
	next_repair = world.time + fire_delay
	new /obj/effect/temp_visual/heal(get_turf(them), COLOR_CYAN)
	tank.reagents.remove_reagent(/datum/reagent/hull_repair_juice, 5)
	//You can repair the main ship too! However at a painfully slow rate. Higher tiers give you vastly better repairs, and bigger ships repair smaller ships way faster.
	them.try_repair(0.5+tier-(them.mass-us.mass))
	//Generals sat from the lines at the back
	us.relay('sound/items/welder.ogg')
	them.relay('sound/items/welder2.ogg')
	if(!current_beam || QDELETED(current_beam))
		current_beam = new(us,them,beam_icon='icons/effects/beam.dmi',time=INFINITY,maxdistance = INFINITY,beam_icon_state="medbeam",btype=/obj/effect/ebeam/medical)
		INVOKE_ASYNC(current_beam, /datum/beam.proc/Start)
