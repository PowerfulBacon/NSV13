/*
Todo:
Ammo loading
Startup sequence
Docking [X]
Unified construction
Death state / Crit mode (Canopy breach?)
Hardpoints [X]
Repair
*/


#define HARDPOINT_SLOT_PRIMARY "Primary"
#define HARDPOINT_SLOT_SECONDARY "Secondary"
#define HARDPOINT_SLOT_UTILITY "Utility"
#define HARDPOINT_SLOT_ARMOUR "Armour"
#define HARDPOINT_SLOT_DOCKING "Docking Module"
#define HARDPOINT_SLOT_CANOPY "Canopy"
#define HARDPOINT_SLOT_FUEL "Fuel Tank"
#define HARDPOINT_SLOT_ENGINE "Engine"
#define HARDPOINT_SLOT_RADAR "Radar"
#define HARDPOINT_SLOT_OXYGENATOR "Atmospheric Regulator"
#define HARDPOINT_SLOT_BATTERY "Battery"
#define HARDPOINT_SLOT_APU "APU"
#define HARDPOINT_SLOT_UTILITY_PRIMARY "Primary Utility"
#define HARDPOINT_SLOT_UTILITY_SECONDARY "Secondary Utility"

#define ALL_HARDPOINT_SLOTS list(HARDPOINT_SLOT_PRIMARY, HARDPOINT_SLOT_SECONDARY,HARDPOINT_SLOT_UTILITY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR, HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU)
#define HARDPOINT_SLOTS_STANDARD list(HARDPOINT_SLOT_PRIMARY, HARDPOINT_SLOT_SECONDARY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR,HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU)
#define HARDPOINT_SLOTS_UTILITY list(HARDPOINT_SLOT_UTILITY_PRIMARY,HARDPOINT_SLOT_UTILITY_SECONDARY, HARDPOINT_SLOT_ARMOUR, HARDPOINT_SLOT_FUEL, HARDPOINT_SLOT_ENGINE, HARDPOINT_SLOT_RADAR,HARDPOINT_SLOT_CANOPY, HARDPOINT_SLOT_OXYGENATOR,HARDPOINT_SLOT_DOCKING, HARDPOINT_SLOT_BATTERY, HARDPOINT_SLOT_APU)

#define LOADOUT_DEFAULT_FIGHTER /datum/component/ship_loadout
#define LOADOUT_UTILITY_ONLY /datum/component/ship_loadout/utility

#define ENGINE_RPM_SPUN 8000

/obj/structure/overmap/fighter/Destroy()
	throw_pilot()
	. = ..()

/obj/structure/overmap/fighter
	name = "Space Fighter"
	icon = 'nsv13/icons/overmap/nanotrasen/fighter.dmi'
	icon = 'nsv13/icons/overmap/nanotrasen/fighter.dmi'
	icon_state = "fighter"
	brakes = TRUE
	armor = list("melee" = 80, "bullet" = 50, "laser" = 80, "energy" = 50, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 80) //temp to stop easy destruction from small arms
	bound_width = 64 //Change this on a per ship basis
	bound_height = 64
	mass = MASS_TINY
	sprite_size = 32
	damage_states = TRUE
	faction = "nanotrasen"
	max_integrity = 200 //Really really squishy!
	forward_maxthrust = 5
	backward_maxthrust = 5
	side_maxthrust = 4
	max_angular_acceleration = 180
	torpedoes = 0
	missiles = 0
	speed_limit = 7 //We want fighters to be way more maneuverable
	weapon_safety = TRUE //This happens wayy too much for my liking. Starts ON.
	pixel_w = -16
	pixel_z = -20
	pixel_collision_size_x = 32
	pixel_collision_size_y = 32 //Avoid center tile viewport jank
	req_one_access = list(ACCESS_FIGHTER)
	var/start_emagged = FALSE
	var/max_passengers = 0 //Change this per fighter.
	//Component to handle the fighter's loadout, weapons, parts, the works.
	var/loadout_type = LOADOUT_DEFAULT_FIGHTER
	var/datum/component/ship_loadout/loadout = null
	var/obj/structure/fighter_launcher/mag_lock = null //Mag locked by a launch pad. Cheaper to use than locate()
	var/canopy_open = TRUE
	var/master_caution = FALSE //The big funny warning light on the dash.
	var/list/components = list() //What does this fighter start off with? Use this to set what engine tiers and whatever it gets.
	var/maintenance_mode = FALSE //Munitions level IDs can change this.
	var/dradis_type =/obj/machinery/computer/ship/dradis/internal
	var/list/fighter_verbs = list(.verb/toggle_brakes, .verb/toggle_inertia, .verb/toggle_safety, .verb/show_dradis, .verb/overmap_help, .verb/toggle_move_mode, .verb/cycle_firemode, \
								.verb/show_control_panel, .verb/change_name)

/obj/structure/overmap/fighter/verb/show_control_panel()
	set name = "Show control panel"
	set category = "Ship"
	set src = usr.loc

	if(!verb_check())
		return
	ui_interact(usr)

/obj/structure/overmap/fighter/verb/change_name()
	set name = "Change name"
	set category = "Ship"
	set src = usr.loc

	if(!verb_check())
		return
	var/new_name = stripped_input(usr, message="What do you want to name \
		your fighter? Keep in mind that particularly terrible names may be \
		rejected by your employers.", max_length=MAX_CHARTER_LEN)
	if(!new_name || length(new_name) <= 0)
		return
	message_admins("[key_name_admin(usr)] renamed a fighter to [new_name] [ADMIN_LOOKUPFLW(src)].")
	name = new_name

/obj/structure/overmap/fighter/start_piloting(mob/living/carbon/user, position)
	user.add_verb(fighter_verbs)
	..()

/obj/structure/overmap/fighter/key_down(key, client/user)
	. = ..()
	var/mob/themob = user.mob
	switch(key)
		if("Capslock")
			if(themob == pilot)
				toggle_safety()
			if(helm && prob(80))
				var/sound = pick(GLOB.computer_beeps)
				playsound(helm, sound, 100, 1)
			return TRUE

/obj/structure/overmap/fighter/ui_state(mob/user)
	return GLOB.contained_state

/obj/structure/overmap/fighter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FighterControls")
		ui.open()

/obj/structure/overmap/fighter/ui_data(mob/user)
	var/list/data = list()
	data["obj_integrity"] = obj_integrity
	data["max_integrity"] = max_integrity
	var/obj/item/fighter_component/armour_plating/A = loadout.get_slot(HARDPOINT_SLOT_ARMOUR)
	data["armour_integrity"] = (A) ? A.obj_integrity : 0
	data["max_armour_integrity"] = (A) ? A.max_integrity : 100

	var/obj/item/fighter_component/battery/B = loadout.get_slot(HARDPOINT_SLOT_BATTERY)
	data["battery_charge"] = B ? B.charge : 0
	data["battery_max_charge"] = B ? B.maxcharge : 0
	data["brakes"] = brakes
	data["inertial_dampeners"] = inertial_dampeners
	data["mag_locked"] = (mag_lock) ? TRUE : FALSE
	data["canopy_lock"] = canopy_open
	data["weapon_safety"] = weapon_safety
	data["master_caution"] = master_caution
	data["rwr"] = (enemies.len) ? TRUE : FALSE
	data["fuel_warning"] = get_fuel() <= get_max_fuel()*0.4
	data["fuel"] = get_fuel()
	data["max_fuel"] = get_max_fuel()
	data["hardpoints"] = list()
	data["maintenance_mode"] = maintenance_mode //Todo
	var/obj/item/fighter_component/docking_computer/DC = loadout.get_slot(HARDPOINT_SLOT_DOCKING)
	data["docking_mode"] = DC && DC.docking_mode
	data["primary_ammo"] = 0
	data["max_primary_ammo"] = 0

	var/obj/item/fighter_component/apu/APU = loadout.get_slot(HARDPOINT_SLOT_APU)
	data["fuel_pump"] = APU ? APU.fuel_line : FALSE

	var/obj/item/fighter_component/battery/battery = loadout.get_slot(HARDPOINT_SLOT_BATTERY)
	data["battery"] = battery? battery.active : battery

	data["apu"] = APU.active
	var/obj/item/fighter_component/engine/engine = loadout.get_slot(HARDPOINT_SLOT_ENGINE)
	data["ignition"] = engine ? engine.active() : FALSE
	data["rpm"] = engine? engine.rpm : 0

	for(var/slot in loadout.equippable_slots)
		var/obj/item/fighter_component/weapon = loadout.hardpoint_slots[slot]
		//Look for any "primary" hardpoints, be those guns or utility slots
		if(!weapon)
			continue
		if(weapon.fire_mode == FIRE_MODE_PDC)
			data["primary_ammo"] = weapon.get_ammo()
			data["max_primary_ammo"] = weapon.get_max_ammo()
		if(weapon.fire_mode == FIRE_MODE_TORPEDO)
			data["secondary_ammo"] = weapon.get_ammo()
			data["max_secondary_ammo"] = weapon.get_max_ammo()
	var/list/hardpoints_info = list()
	var/list/occupants_info = list()
	for(var/obj/item/fighter_component/FC in contents)
		if(isliving(FC))
			var/mob/living/L = FC
			var/list/occupant_info = list()
			occupant_info["name"] = L.name
			occupant_info["id"] = "\ref[L]"
			occupant_info["afk"] = (L.mind) ? "Active" : "Inactive (SSD)"
			occupants_info[++occupants_info.len] = occupant_info
			continue
		if(!istype(FC))
			continue
		var/list/hardpoint_info = list()
		hardpoint_info["name"] = FC.name
		hardpoint_info["desc"] = FC.desc
		hardpoint_info["id"] = "\ref[FC]"
		hardpoints_info[++hardpoints_info.len] = hardpoint_info
	data["hardpoints"] = hardpoints_info
	data["occupants_info"] = occupants_info
	return data

/obj/structure/overmap/fighter/ui_act(action, params, datum/tgui/ui)
	if(..() || usr != pilot)
		return
	var/atom/movable/target = locate(params["id"])
	switch(action)
		if("examine")
			if(!target)
				return
			to_chat(usr, "<span class='notice'>[target.desc]</span>")
		if("eject_hardpoint")
			if(!target)
				return
			var/obj/item/fighter_component/FC = target
			if(!istype(FC))
				return
			to_chat(usr, "<span class='notice'>You start uninstalling [target.name] from [src].</span>")
			if(!do_after(usr, 5 SECONDS, target=src))
				return
			to_chat(usr, "<span class='notice>You uninstall [target.name] from [src].</span>")
			loadout.remove_hardpoint(FC, FALSE)
		if("dump_hardpoint")
			if(!target)
				return
			var/obj/item/fighter_component/FC = target
			if(!istype(FC) || !FC.contents?.len)
				return
			to_chat(usr, "<span class='notice'>You start to unload [target.name]'s stored contents...</span>")
			if(!do_after(usr, 5 SECONDS, target=src))
				return
			to_chat(usr, "<span class='notice>You dump [target.name]'s contents.</span>")
			loadout.dump_contents(FC)
		if("kick")
			if(!target)
				return
			if(!allowed(usr) || usr != pilot)
				return
			var/mob/living/L = target
			to_chat(L, "<span class='warning'>You have been kicked out of [src] by the pilot.</span>")
			canopy_open = FALSE
			toggle_canopy()
			stop_piloting(L)
		if("fuel_pump")
			var/obj/item/fighter_component/apu/APU = loadout.get_slot(HARDPOINT_SLOT_APU)
			if(!APU)
				to_chat(usr, "<span class='warning'>You can't send fuel to an APU that isn't installed.</span>")
				return
			var/obj/item/fighter_component/engine/engine = loadout.get_slot(HARDPOINT_SLOT_ENGINE)
			if(!engine)
				to_chat(usr, "<span class='warning'>You can't send fuel to an APU that isn't installed.</span>")
			APU.toggle_fuel_line()
			playsound(src, 'nsv13/sound/effects/fighters/warmup.ogg', 100, FALSE)
		if("battery")
			var/obj/item/fighter_component/battery/battery = loadout.get_slot(HARDPOINT_SLOT_BATTERY)
			if(!battery)
				to_chat(usr, "<span class='warning'>[src] does not have a battery installed!</span>")
				return
			battery.toggle()
			to_chat(usr, "You flip the battery switch.</span>")
		if("apu")
			var/obj/item/fighter_component/apu/APU = loadout.get_slot(HARDPOINT_SLOT_APU)
			if(!APU)
				to_chat(usr, "<span class='warning'>[src] does not have an APU installed!</span>")
				return
			APU.toggle()
			playsound(src, 'nsv13/sound/effects/fighters/warmup.ogg', 100, FALSE)
		if("ignition")
			var/obj/item/fighter_component/engine/engine = loadout.get_slot(HARDPOINT_SLOT_ENGINE)
			if(!engine)
				to_chat(usr, "<span class='warning'>[src] does not have an engine installed!</span>")
				return
			engine.try_start()
		if("canopy_lock")
			toggle_canopy()
		if("docking_mode")
			var/obj/item/fighter_component/docking_computer/DC = loadout.get_slot(HARDPOINT_SLOT_DOCKING)
			if(!DC || !istype(DC))
				to_chat(usr, "<span class='warning'>[src] does not have a docking computer installed!</span>")
				return
			to_chat(usr, "<span class='notice'>You [DC.docking_mode ? "disengage" : "engage"] [src]'s docking computer.</span>")
			DC.docking_mode = !DC.docking_mode
			relay('nsv13/sound/effects/fighters/switch.ogg')
			return
		if("brakes")
			toggle_brakes()
			relay('nsv13/sound/effects/fighters/switch.ogg')
			return
		if("inertial_dampeners")
			toggle_inertia()
			relay('nsv13/sound/effects/fighters/switch.ogg')
			return
		if("weapon_safety")
			toggle_safety()
			relay('nsv13/sound/effects/fighters/switch.ogg')
			return
		if("target_lock")
			relay('nsv13/sound/effects/fighters/switch.ogg')
			return
		if("mag_release")
			if(!mag_lock)
				return
			mag_lock.abort_launch()
		if("master_caution")
			set_master_caution(FALSE)
			return
		if("show_dradis")
			dradis.ui_interact(usr)
			return
	relay('nsv13/sound/effects/fighters/switch.ogg')

/obj/structure/overmap/fighter/light
	name = "Su-818 Rapier"
	desc = "An Su-818 Rapier space superiorty fighter craft. Designed for high maneuvreability and maximum combat effectivness against other similar weight classes."
	icon = 'nsv13/icons/overmap/nanotrasen/fighter.dmi'
	armor = list("melee" = 60, "bullet" = 60, "laser" = 60, "energy" = 30, "bomb" = 30, "bio" = 100, "rad" = 90, "fire" = 90, "acid" = 80, "overmap_light" = 10, "overmap_heavy" = 5)
	sprite_size = 32
	damage_states = FALSE //temp
	max_integrity = 200 //Really really squishy!
	max_angular_acceleration = 200
	speed_limit = 10
	pixel_w = -16
	pixel_z = -20
	components = list(/obj/item/fighter_component/fuel_tank,
						/obj/item/fighter_component/avionics,
						/obj/item/fighter_component/apu,
						/obj/item/fighter_component/armour_plating,
						/obj/item/fighter_component/targeting_sensor,
						/obj/item/fighter_component/engine,
						/obj/item/fighter_component/countermeasure_dispenser,
						/obj/item/fighter_component/secondary/ordnance_launcher,
						/obj/item/fighter_component/oxygenator,
						/obj/item/fighter_component/canopy,
						/obj/item/fighter_component/docking_computer,
						/obj/item/fighter_component/battery,
						/obj/item/fighter_component/primary/cannon)

//FL gets a hotrod
/obj/structure/overmap/fighter/light/flight_leader
	req_one_access = list(ACCESS_FL)
	icon_state = "ace"
	components = list(/obj/item/fighter_component/fuel_tank/tier2,
						/obj/item/fighter_component/avionics,
						/obj/item/fighter_component/apu,
						/obj/item/fighter_component/armour_plating/tier2,
						/obj/item/fighter_component/targeting_sensor,
						/obj/item/fighter_component/engine/tier2,
						/obj/item/fighter_component/countermeasure_dispenser,
						/obj/item/fighter_component/secondary/ordnance_launcher,
						/obj/item/fighter_component/oxygenator,
						/obj/item/fighter_component/canopy,
						/obj/item/fighter_component/docking_computer,
						/obj/item/fighter_component/battery,
						/obj/item/fighter_component/primary/cannon)

/obj/structure/overmap/fighter/utility
	name = "Su-437 Sabre"
	desc = "A Su-437 Sabre utility vessel. Designed for robustness in deep space and as a highly modular platform, able to be fitted out for any situation. Drag and drop crates / ore boxes to load them into its cargo hold."
	icon = 'nsv13/icons/overmap/nanotrasen/carrier.dmi'
	icon_state = "carrier"
	armor = list("melee" = 70, "bullet" = 70, "laser" = 70, "energy" = 40, "bomb" = 40, "bio" = 100, "rad" = 90, "fire" = 90, "acid" = 80, "overmap_light" = 15, "overmap_heavy" = 0)
	sprite_size = 32
	damage_states = FALSE //temp
	max_integrity = 250 //Tanky
	max_passengers = 6
	pixel_w = -16
	pixel_z = -20
	req_one_access = list(ACCESS_MUNITIONS, ACCESS_ENGINE, ACCESS_FIGHTER)

	forward_maxthrust = 5
	backward_maxthrust = 5
	side_maxthrust = 5
	max_angular_acceleration = 100
	speed_limit = 6
//	ftl_goal = 45 SECONDS //Raptors can, by default, initiate relative FTL jumps to other ships.
	loadout_type = LOADOUT_UTILITY_ONLY
	dradis_type = /obj/machinery/computer/ship/dradis/internal/awacs //Sabres can send sonar pulses
	components = list(/obj/item/fighter_component/fuel_tank/tier2,
						/obj/item/fighter_component/avionics,
						/obj/item/fighter_component/apu,
						/obj/item/fighter_component/armour_plating,
						/obj/item/fighter_component/targeting_sensor,
						/obj/item/fighter_component/engine,
						/obj/item/fighter_component/oxygenator,
						/obj/item/fighter_component/canopy,
						/obj/item/fighter_component/docking_computer,
						/obj/item/fighter_component/battery,
						/obj/item/fighter_component/primary/utility/hold,
						/obj/item/fighter_component/secondary/utility/resupply,
						/obj/item/fighter_component/countermeasure_dispenser)

/obj/structure/overmap/fighter/utility/mining
	icon = 'nsv13/icons/overmap/nanotrasen/carrier_mining.dmi'
	req_one_access = list(ACCESS_CARGO, ACCESS_MINING, ACCESS_MUNITIONS, ACCESS_ENGINE, ACCESS_FIGHTER)

/obj/structure/overmap/fighter/escapepod
	name = "Escape Pod"
	desc = "An escape pod launched from a space faring vessel. It only has very limited thrusters and is thus very slow."
	icon = 'nsv13/icons/overmap/nanotrasen/escape_pod.dmi'
	icon_state = "escape_pod"
	damage_states = FALSE
	bound_width = 32 //Change this on a per ship basis
	bound_height = 32
	pixel_z = 0
	pixel_w = 0
	max_integrity = 50 //Able to withstand more punishment so that people inside it don't get yeeted as hard
	speed_limit = 2 //This, for reference, will feel suuuuper slow, but this is intentional
	loadout_type = LOADOUT_UTILITY_ONLY
	components = list(/obj/item/fighter_component/fuel_tank,
						/obj/item/fighter_component/avionics,
						/obj/item/fighter_component/apu,
						/obj/item/fighter_component/armour_plating,
						/obj/item/fighter_component/targeting_sensor,
						/obj/item/fighter_component/engine,
						/obj/item/fighter_component/oxygenator,
						/obj/item/fighter_component/canopy,
						/obj/item/fighter_component/docking_computer,
						/obj/item/fighter_component/battery,
						/obj/item/fighter_component/countermeasure_dispenser)

/obj/structure/overmap/fighter/heavy
	name = "Su-410 Scimitar"
	desc = "An Su-410 Scimitar heavy attack craft. It's a lot beefier than its Rapier cousin and is designed to take out capital ships, due to the weight of its modules however, it is extremely slow."
	icon = 'nsv13/icons/overmap/nanotrasen/heavy_fighter.dmi'
	icon_state = "heavy_fighter"
	armor = list("melee" = 80, "bullet" = 80, "laser" = 80, "energy" = 50, "bomb" = 50, "bio" = 100, "rad" = 90, "fire" = 90, "acid" = 80, "overmap_light" = 25, "overmap_heavy" = 10)
	sprite_size = 32
	damage_states = FALSE //TEMP
	max_integrity = 300 //Not so squishy!
	pixel_w = -16
	pixel_z = -20
	speed_limit = 8
	forward_maxthrust = 8
	backward_maxthrust = 8
	side_maxthrust = 7.75
	max_angular_acceleration = 80
	components = list(/obj/item/fighter_component/fuel_tank,
						/obj/item/fighter_component/avionics,
						/obj/item/fighter_component/apu,
						/obj/item/fighter_component/armour_plating,
						/obj/item/fighter_component/targeting_sensor,
						/obj/item/fighter_component/engine,
						/obj/item/fighter_component/countermeasure_dispenser,
						/obj/item/fighter_component/oxygenator,
						/obj/item/fighter_component/canopy,
						/obj/item/fighter_component/docking_computer,
						/obj/item/fighter_component/secondary/ordnance_launcher/torpedo,
						/obj/item/fighter_component/battery,
						/obj/item/fighter_component/primary/cannon/heavy)

//Syndie counterparts.
/obj/structure/overmap/fighter/light/syndicate //PVP MODE
	name = "Syndicate Light Fighter"
	desc = "The Syndicate's answer to Nanotrasen's light fighter craft, this fighter is designed to maintain aerial supremacy."
	icon = 'nsv13/icons/overmap/syndicate/syn_viper.dmi'
	req_one_access = ACCESS_SYNDICATE
	faction = "syndicate"
	start_emagged = TRUE

/obj/structure/overmap/fighter/utility/syndicate //PVP MODE
	name = "Syndicate Utility Vessel"
	desc = "A boarding craft for rapid troop deployment."
	icon = 'nsv13/icons/overmap/syndicate/syn_raptor.dmi'
	req_one_access = ACCESS_SYNDICATE
	faction = "syndicate"
	start_emagged = TRUE

/obj/structure/overmap/fighter/Initialize(mapload, list/build_components=components)
	. = ..()
	apply_weapons()
	loadout = AddComponent(loadout_type)
	dradis = new dradis_type(src) //Fighters need a way to find their way home.
	dradis.linked = src
	obj_integrity = max_integrity
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, .proc/check_overmap_elegibility) //Used to smoothly transition from ship to overmap
	add_overlay(image(icon = icon, icon_state = "canopy_open", dir = SOUTH))
	var/obj/item/fighter_component/engine/engineGoesLast = null
	if(build_components.len)
		for(var/Ctype in build_components)
			var/obj/item/fighter_component/FC = new Ctype(get_turf(src))
			if(istype(FC, /obj/item/fighter_component/engine))
				engineGoesLast = FC
				continue
			loadout.install_hardpoint(FC)
	//Engines need to be the last thing that gets installed on init, or it'll cause bugs with drag.
	if(engineGoesLast)
		loadout.install_hardpoint(engineGoesLast)
	obj_integrity = max_integrity //Update our health to reflect how much armour we've been given.
	set_fuel(rand(500, 1000))
	if(start_emagged)
		obj_flags ^= EMAGGED

/obj/structure/overmap/fighter/attackby(obj/item/W, mob/user, params)
	if(operators && LAZYFIND(operators, user))
		to_chat(user, "<span class='warning'>You can't reach [src]'s exterior from in here..</span>")
		return FALSE
	for(var/slot in loadout.equippable_slots)
		var/obj/item/fighter_component/FC = loadout.get_slot(slot)
		if(FC?.load(src, W))
			return FALSE
	if(istype(W, /obj/item/fighter_component))
		var/obj/item/fighter_component/FC = W
		loadout.install_hardpoint(FC)
		return FALSE
	..()

/obj/structure/overmap/fighter/MouseDrop_T(atom/movable/target, mob/user)
	. = ..()
	if(!isliving(user))
		return FALSE
	for(var/slot in loadout.equippable_slots)
		var/obj/item/fighter_component/FC = loadout.get_slot(slot)
		if(FC?.load(src, target))
			return FALSE
	if(allowed(user))
		if(!canopy_open)
			playsound(src, 'sound/effects/glasshit.ogg', 75, 1)
			user.visible_message("<span class='warning'>You bang on the canopy.</span>", "<span class='warning'>[user] bangs on [src]'s canopy.</span>")
			return FALSE
		if(operators.len >= max_passengers)
			to_chat(user, "<span class='warning'>[src]'s passenger compartment is full!")
			return FALSE
		to_chat(target, "[(user == target) ? "You start to climb into [src]'s passenger compartment" : "[user] starts to lift you into [src]'s passenger compartment"]")
		if(do_after(user, 2 SECONDS, target=src))
			start_piloting(user, "observer")
			enter(user)
	else
		to_chat(user, "<span class='warning'>Access denied.</span>")

/obj/structure/overmap/fighter/proc/enter(mob/user)
	user.forceMove(src)
	mobs_in_ship += user
	if((user.client?.prefs.toggles & SOUND_AMBIENCE) && user.can_hear_ambience() && engines_active()) //Disable ambient sounds to shut up the noises.
		SEND_SOUND(user, sound('nsv13/sound/effects/fighters/cockpit.ogg', repeat = TRUE, wait = 0, volume = 50, channel=CHANNEL_SHIP_ALERT))

/obj/structure/overmap/fighter/stop_piloting(mob/living/M, force=FALSE)
	if(!canopy_open && !force)
		to_chat(M, "<span class='warning'>[src]'s canopy isn't open.</span>")
		if(prob(50))
			playsound(src, 'sound/effects/glasshit.ogg', 75, 1)
			to_chat(M, "<span class='warning'>You bump your head on [src]'s canopy.</span>")
			visible_message("<span class='warning'>You hear a muffled thud.</span>")
		return
	if(!SSmapping.level_trait(loc.z, ZTRAIT_BOARDABLE) && !force)
		to_chat(M, "<span class='warning'>[src] won't let you jump out of it mid flight.</span>")
		return FALSE
	mobs_in_ship -= M
	. = ..()
	M.stop_sound_channel(CHANNEL_SHIP_ALERT)
	M.forceMove(get_turf(src))
	M.remove_verb(fighter_verbs)
	return TRUE

/obj/structure/overmap/fighter/attack_hand(mob/user)
	. = ..()
	if(allowed(user))
		if(pilot)
			to_chat(user, "<span class='notice'>[src] already has a pilot.</span>")
			return FALSE
		if(do_after(user, 2 SECONDS, target=src))
			enter(user)
			start_piloting(user, "all_positions")
			to_chat(user, "<span class='notice'>You climb into [src]'s cockpit.</span>")
			ui_interact(user)
			return TRUE

/obj/structure/overmap/fighter/proc/force_eject(force=FALSE)
	RETURN_TYPE(/list)
	var/list/victims = list()
	brakes = TRUE
	if(!canopy_open)
		canopy_open = TRUE
		playsound(src, 'nsv13/sound/effects/fighters/canopy.ogg', 100, 1)
	for(var/mob/M in operators)
		stop_piloting(M, force)
		to_chat(M, "<span class='warning'>You have been remotely ejected from [src]!.</span>")
		victims += M
	return victims

//Iconic proc.
/obj/structure/overmap/fighter/proc/foo()
	set_fuel(1000)
	var/obj/item/fighter_component/apu/APU = loadout.get_slot(HARDPOINT_SLOT_APU)
	APU.fuel_line = TRUE
	var/obj/item/fighter_component/battery/B = loadout.get_slot(HARDPOINT_SLOT_BATTERY)
	B.active = TRUE
	B.charge = B.maxcharge
	var/obj/item/fighter_component/engine/E = loadout.get_slot(HARDPOINT_SLOT_ENGINE)
	E.rpm = ENGINE_RPM_SPUN
	E.try_start()
	toggle_canopy()
	forceMove(get_turf(locate(world.maxx, y, z)))

/obj/structure/overmap/fighter/proc/throw_pilot() //Used when yeeting a pilot out of an exploding ship
	if(SSmapping.level_trait(z, ZTRAIT_OVERMAP)) //Check if we're on the overmap
		var/max = world.maxx-TRANSITIONEDGE
		var/min = 1+TRANSITIONEDGE

		var/list/possible_transitions = list()
		for(var/A in SSmapping.z_list)
			var/datum/space_level/D = A
			if (D.linkage == CROSSLINKED && !SSmapping.level_trait(D.z_value, ZTRAIT_OVERMAP))
				possible_transitions += D.z_value
			if(!possible_transitions.len) //Just in case there is no space z level
				for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
					possible_transitions += z

		var/_z = pick(possible_transitions)
		var/_x
		var/_y

		switch(dir)
			if(SOUTH)
				_x = rand(min,max)
				_y = max
			if(WEST)
				_x = max
				_y = rand(min,max)
			if(EAST)
				_x = min
				_y = rand(min,max)
			else
				_x = rand(min,max)
				_y = min

		var/turf/T = locate(_x, _y, _z) //Where are we putting you
		var/list/victims = force_eject(TRUE)
		for(var/mob/living/M in victims)
			M.forceMove(T)
			M.apply_damage(400) //No way you're surviving that

	else //If we're anywhere that isn't the overmap
		var/list/victims = force_eject(TRUE)
		for(var/mob/living/M in victims)
			M.apply_damage(200)

/obj/structure/overmap/fighter/attackby(obj/item/W, mob/user, params)   //fueling and changing equipment
	add_fingerprint(user)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda) && operators.len)
		if(!allowed(user))
			var/sound = pick('nsv13/sound/effects/computer/error.ogg','nsv13/sound/effects/computer/error2.ogg','nsv13/sound/effects/computer/error3.ogg')
			playsound(src, sound, 100, 1)
			to_chat(user, "<span class='warning'>Access denied</span>")
			return
		if(alert("What do you want to do?",name,"Eject Occupants","Maintenance Mode") == "Eject Occupants")
			if(!Adjacent(user))
				return
			to_chat(user, "<span class='warning'>Ejecting all current occupants from [src] and activating inertial dampeners...</span>")
			force_eject()
		else
			if(!Adjacent(user))
				return
			to_chat(user, "<span class='warning'>You swipe your card and [maintenance_mode ? "disable" : "enable"] maintenance protocols.</span>")
			maintenance_mode = !maintenance_mode
	..()

/obj/structure/overmap/fighter/take_damage(damage_amount, damage_type, damage_flag, sound_effect)
	var/obj/item/fighter_component/armour_plating/A = loadout.get_slot(HARDPOINT_SLOT_ARMOUR)
	if(A && istype(A))
		A.take_damage(damage_amount, damage_type, damage_flag, sound_effect)
		if(A.obj_integrity <= 0)
			loadout.remove_hardpoint(A, TRUE)
			qdel(A) //There goes your armour!
		relay(pick('nsv13/sound/effects/ship/freespace2/ding1.wav', 'nsv13/sound/effects/ship/freespace2/ding2.wav', 'nsv13/sound/effects/ship/freespace2/ding3.wav', 'nsv13/sound/effects/ship/freespace2/ding4.wav', 'nsv13/sound/effects/ship/freespace2/ding5.wav'))
	else
		. = ..()
	var/obj/item/fighter_component/canopy/C = loadout.get_slot(HARDPOINT_SLOT_CANOPY)
	if(!C) //Riding without a canopy is not without consequences
		if(prob(30)) //Ouch!
			for(var/mob/living/M in contents)
				to_chat(M , "<span class='warning'>You feel something hit you!</span>")
				M.take_overall_damage(damage_amount/2)
		return
	if(prob(50))
		relay('sound/effects/glasshit.ogg')
		C.take_damage(damage_amount/2, damage_type, damage_flag, sound_effect)
		if(C.obj_integrity <= 0)
			canopy_breach(C)

/obj/structure/overmap/fighter/proc/canopy_breach(obj/item/fighter_component/canopy/C)
	relay('nsv13/sound/effects/ship/cockpit_breach.ogg') //We're leaking air!
	loadout.remove_hardpoint(HARDPOINT_SLOT_CANOPY, TRUE)
	qdel(C) //Pop off the canopy.
	sleep(2 SECONDS)
	relay('nsv13/sound/effects/ship/reactor/gasmask.ogg', "<span class='warning'>The air around you rushes out of the breached canopy!</span>", loop = FALSE, channel = CHANNEL_SHIP_ALERT)
	return

/obj/structure/overmap/fighter/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(obj_integrity >= max_integrity)
		to_chat(user, "<span class='notice'>[src] isn't in need of repairs.</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You start welding some dents out of [src]'s hull...</span>")
	if(I.use_tool(src, user, 4 SECONDS, volume=100))
		to_chat(user, "<span class='notice'>You weld some dents out of [src]'s hull.</span>")
		obj_integrity += min(10, max_integrity-obj_integrity)
		return TRUE

//Fuel
/obj/structure/overmap/fighter/proc/get_fuel()
	var/obj/item/fighter_component/fuel_tank/ft = loadout.get_slot(HARDPOINT_SLOT_FUEL)
	. = 0
	for(var/datum/reagent/aviation_fuel/F in ft?.reagents.reagent_list)
		if(!istype(F))
			continue
		. += F.volume
	return .

/obj/structure/overmap/fighter/proc/set_fuel(amount)
	var/obj/item/fighter_component/fuel_tank/ft = loadout.get_slot(HARDPOINT_SLOT_FUEL)
	if(!ft)
		return FALSE
	ft.reagents.add_reagent(/datum/reagent/aviation_fuel, 1) //Assert that we have this reagent in the tank.
	for(var/datum/reagent/aviation_fuel/F in ft?.reagents.reagent_list)
		if(!istype(F))
			continue
		F.volume = amount
	return amount

/obj/structure/overmap/fighter/proc/engines_active()
	var/obj/item/fighter_component/engine/E = loadout.get_slot(HARDPOINT_SLOT_ENGINE)//E's are good E's are good, he's ebeneezer goode.
	return (E?.active() && get_fuel() > 0)

/obj/structure/overmap/fighter/proc/set_master_caution(state)
	var/master_caution_switch = state
	if(master_caution_switch)
		relay('nsv13/sound/effects/fighters/master_caution.ogg', null, loop=TRUE, channel=CHANNEL_HEARTBEAT)
		master_caution = TRUE
	else
		stop_relay(CHANNEL_HEARTBEAT) //CONSIDER MAKING OWN CHANNEL
		master_caution = FALSE

/obj/structure/overmap/fighter/proc/use_fuel(force=FALSE)
	if(!engines_active() && !force) //No fuel? don't spam them with master cautions / use any fuel
		return FALSE
	var/fuel_consumption = 0.5*(loadout.get_slot(HARDPOINT_SLOT_ENGINE)?.tier)
	var/amount = (user_thrust_dir) ? fuel_consumption+0.25 : fuel_consumption //When you're thrusting : fuel consumption doubles. Idling is cheap.
	var/obj/item/fighter_component/fuel_tank/ft = loadout.get_slot(HARDPOINT_SLOT_FUEL)
	if(!ft)
		return FALSE
	ft.reagents.remove_reagent(/datum/reagent/aviation_fuel, amount)
	if(get_fuel() >= amount)
		return TRUE
	set_master_caution(TRUE)
	return FALSE

/obj/structure/overmap/fighter/can_move()
	return (engines_active())

/obj/structure/overmap/fighter/proc/empty_fuel_tank()//Debug purposes, for when you need to drain a fighter's tank entirely.
	var/obj/item/fighter_component/fuel_tank/ft = loadout.get_slot(HARDPOINT_SLOT_FUEL)
	if(!ft)
		return FALSE
	ft.reagents.clear_reagents()

/obj/structure/overmap/fighter/proc/get_max_fuel()
	var/obj/item/fighter_component/fuel_tank/ft = loadout.get_slot(HARDPOINT_SLOT_FUEL)
	if(!ft)
		return 0
	return ft.reagents.maximum_volume

//Ensure we get the genericised equipment mounts.
/obj/structure/overmap/fighter/apply_weapons()
	if(!weapon_types[FIRE_MODE_PDC])
		weapon_types[FIRE_MODE_PDC] = new/datum/ship_weapon/fighter_primary(src)
	if(!weapon_types[FIRE_MODE_TORPEDO])
		weapon_types[FIRE_MODE_TORPEDO] = new/datum/ship_weapon/fighter_secondary(src)

/obj/structure/overmap/proc/primary_fire(obj/structure/overmap/target)
	hardpoint_fire(target, FIRE_MODE_PDC)

/obj/structure/overmap/proc/hardpoint_fire(obj/structure/overmap/target, fireMode)
	if(istype(src, /obj/structure/overmap/fighter))
		var/obj/structure/overmap/fighter/F = src
		for(var/slot in F.loadout.equippable_slots)
			var/obj/item/fighter_component/weapon = F.loadout.hardpoint_slots[slot]
			//Look for any "primary" hardpoints, be those guns or utility slots
			if(!weapon || weapon.fire_mode != fireMode)
				continue
			var/datum/ship_weapon/SW = weapon_types[weapon.fire_mode]
			for(var/I = 0; I < SW.burst_size; I++)
				weapon.fire(target)
				sleep(1)
			return TRUE
	return FALSE

/obj/structure/overmap/proc/secondary_fire(obj/structure/overmap/target)
	hardpoint_fire(target, FIRE_MODE_TORPEDO)

/obj/structure/overmap/fighter/update_icon()
	cut_overlays()
	..()
	var/obj/item/fighter_component/canopy/C = loadout?.get_slot(HARDPOINT_SLOT_CANOPY)
	if(!C)
		add_overlay(image(icon = icon, icon_state = "canopy_missing", dir = 1))
		return
	if(C.obj_integrity <= 20)
		add_overlay(image(icon = icon, icon_state = "canopy_breach", dir = 1))
		return
	if(canopy_open)
		add_overlay("canopy_open")

/obj/structure/overmap/fighter/slowprocess()
	..()
	if(engines_active())
		use_fuel()
		loadout.process()

	var/obj/item/fighter_component/canopy/C = loadout.get_slot(HARDPOINT_SLOT_CANOPY)
	if(!C || (C.obj_integrity <= 0)) //Leak air if the canopy is breached.
		var/datum/gas_mixture/removed = cabin_air.remove(5)
		qdel(removed)
	update_icon()

/obj/structure/overmap/fighter/return_air()
	var/obj/item/fighter_component/canopy/C = loadout.get_slot(HARDPOINT_SLOT_CANOPY)
	if(canopy_open || !C)
		return loc.return_air()
	return cabin_air

/obj/structure/overmap/fighter/remove_air(amount)
	return cabin_air?.remove(amount)

/obj/structure/overmap/fighter/return_analyzable_air()
	return cabin_air

/obj/structure/overmap/fighter/return_temperature()
	var/datum/gas_mixture/t_air = return_air()
	if(t_air)
		. = t_air.return_temperature()
	return

/obj/structure/overmap/fighter/portableConnectorReturnAir()
	return return_air()

/obj/structure/overmap/fighter/assume_air(datum/gas_mixture/giver)
	var/datum/gas_mixture/t_air = return_air()
	return t_air.merge(giver)

/obj/structure/overmap/fighter/proc/toggle_canopy()
	canopy_open = !canopy_open
	playsound(src, 'nsv13/sound/effects/fighters/canopy.ogg', 100, 1)

/obj/structure/overmap/fighter/utility/prebuilt/carrier //This needs to be resolved properly later
