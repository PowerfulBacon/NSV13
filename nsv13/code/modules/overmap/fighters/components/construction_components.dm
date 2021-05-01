//Construction only components

/obj/item/fighter_component/avionics
	name = "Fighter Avionics"
	desc = "Avionics for a fighter"
	icon = 'nsv13/icons/obj/fighter_components.dmi'
	icon_state = "avionics"

/obj/item/fighter_component/apu
	name = "Fighter Auxiliary Power Unit"
	desc = "An Auxiliary Power Unit for a fighter"
	icon = 'nsv13/icons/obj/fighter_components.dmi'
	icon_state = "apu"
	slot = HARDPOINT_SLOT_APU
	tier = 1
	active = FALSE
	var/fuel_line = FALSE
	var/next_process = 0

/obj/item/fighter_component/apu/tier2
	name = "Upgraded fighter APU"
	tier = 2

/obj/item/fighter_component/apu/tier3
	name = "Super fighter APU"
	desc = "A small engine capable of rapidly starting a fighter."
	tier = 3

/obj/item/fighter_component/apu/proc/toggle_fuel_line()
	fuel_line = !fuel_line

/obj/item/fighter_component/apu/process()
	if(!..())
		return
	if(world.time < next_process)
		return
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return FALSE
	next_process = world.time + 4 SECONDS
	if(!fuel_line)
		return //APU needs fuel to drink
	playsound(F, 'nsv13/sound/effects/fighters/apu_loop.ogg', 70, FALSE)
	var/obj/item/fighter_component/engine/engine = F.loadout.get_slot(HARDPOINT_SLOT_ENGINE)
	F.use_fuel(2, TRUE) //APUs take fuel to run.
	if(engine.active())
		return
	engine.apu_spin(500*tier)


/obj/item/fighter_component/countermeasure_dispenser
	name = "Fighter Countermeasure Dispenser"
	desc = "A device which allows a fighter to deploy countermeasures."
	icon = 'nsv13/icons/obj/fighter_components.dmi'
	icon_state = "countermeasure"

/obj/item/fighter_component/docking_computer
	name = "Docking Computer"
	desc = "A computer that allows fighters to easily dock to a ship"
	icon_state = "docking_computer"
	slot = HARDPOINT_SLOT_DOCKING
	tier = null //Not upgradable right now.
	var/docking_mode = FALSE
	var/docking_cooldown = FALSE
