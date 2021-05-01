/obj/item/fighter_component/secondary/utility
	name = "Utility Module"
	slot = HARDPOINT_SLOT_UTILITY_SECONDARY
	power_usage = 200

/obj/item/fighter_component/secondary/utility/resupply
	name = "Air to Air Resupply Kit"
	desc = "A large hose line which can allow a utility craft to perform air to air refuelling and resupply, without needing to RTB!"
	icon_state = "resupply"
	overmap_firing_sounds = list(
		'nsv13/sound/effects/fighters/refuel.ogg')
	fire_delay = 6 SECONDS
	var/datum/beam/current_beam
	var/next_fuel = 0

/obj/item/fighter_component/secondary/utility/resupply/get_ammo()
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return 0
	return F.get_fuel()

/obj/item/fighter_component/secondary/utility/resupply/get_max_ammo()
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return 0
	return F.get_max_fuel()

/obj/item/fighter_component/secondary/utility/resupply/tier2
	name = "Upgraded Air To Air Resupply Kit"
	fire_delay = 5 SECONDS
	tier = 2

/obj/item/fighter_component/secondary/utility/resupply/tier3
	name = "Super Air To Air Resupply Kit"
	fire_delay = 3 SECONDS
	tier = 3

/obj/item/fighter_component/secondary/utility/resupply/process()
	if(!..())
		return
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F) || !F.autofire_target || F.fire_mode != fire_mode)
		qdel(current_beam)
		current_beam = null
		return FALSE
	if(world.time < next_fuel)
		return FALSE
	var/obj/structure/overmap/fighter/them = F.autofire_target
	if(!istype(them) || them == F) //No self targeting
		return FALSE
	next_fuel = world.time + fire_delay
	if(!current_beam || QDELETED(current_beam))
		current_beam = new(F,them,beam_icon='nsv13/icons/effects/beam.dmi',time=INFINITY,maxdistance = INFINITY,beam_icon_state="hose",btype=/obj/effect/ebeam/fuel_hose)
		INVOKE_ASYNC(current_beam, /datum/beam.proc/Start)

	//Firstly, try to refuel the friendly.
	var/obj/item/fighter_component/fuel_tank/fuel = F.loadout.get_slot(HARDPOINT_SLOT_FUEL)
	if(!fuel || F.get_fuel() <= 0)
		goto resupplyFuel
	var/obj/item/fighter_component/fuel_tank/theirFuel = them.loadout.get_slot(HARDPOINT_SLOT_FUEL)
	var/transfer_amount = min(50, them.get_max_fuel()-them.get_fuel()) //Transfer as much as we can
	transfer_amount = CLAMP(transfer_amount, 0, 100)//Don't want to overfill them
	F.relay('nsv13/sound/effects/fighters/refuel.ogg')
	them.relay('nsv13/sound/effects/fighters/refuel.ogg')
	var/obj/item/fighter_component/battery/B = them.loadout.get_slot(HARDPOINT_SLOT_BATTERY)
	if(B && istype(B))
		B.give(100) //Jumpstart their battery
	if(transfer_amount <= 0)
		goto resupplyFuel
	fuel.reagents.trans_to(theirFuel, transfer_amount)
	resupplyFuel:
	var/obj/item/fighter_component/primary/utility/hold = F.loadout.get_slot(HARDPOINT_SLOT_UTILITY_PRIMARY)
	if(!istype(hold))
		return FALSE
	var/obj/item/fighter_component/primary/theirGun = them.loadout.get_slot(HARDPOINT_SLOT_PRIMARY)
	var/obj/item/fighter_component/primary/theirTorp = them.loadout.get_slot(HARDPOINT_SLOT_SECONDARY)
	//Next up, try to refill the friendly's guns from whatever we have stored in cargo.
	for(var/atom/movable/AM in hold.contents)
		if(theirGun.load(them, AM))
			continue
		if(theirTorp.load(them, AM))
			continue
