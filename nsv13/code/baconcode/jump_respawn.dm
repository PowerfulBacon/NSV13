
/*
 * Respawns players who are dead.
 */
/obj/structure/overmap/proc/after_jump_completed(datum/star_system/target_system, ftl_start)

	//Post message
	var/popcount = SSticker.gather_roundend_feedback()
	to_chat("===============================")
	to_chat("<span class='userdanger'>Round Completed</span>")
	to_chat("<span class='danger'>Ship integrity: [popcount["station_integrity"]]%]</span>")
	to_chat("<span class='danger'>Players alive: [popcount[POPCOUNT_SURVIVORS]]</span>")
	to_chat("===============================")
	to_chat("<span class='notice'>THE NEXT ROUND WILL BEGIN IN 120 SECONDS.</span>")
	to_chat("<span class='notice'>Prepare the ship for combat!</span>")
	to_chat("===============================")
	SSticker.display_report(popcount)

	//Reset occupations
	SSjob.ResetOccupations()

	//Restart game
	SSticker.mode.end_gamemode()

	//Respawn people.
	for(var/mob/M in GLOB.player_list)
		//Forcemove to a spawn
		GLOB.start_landmarks_list = shuffle(GLOB.start_landmarks_list)
		//Create character
		//var/mob/living/carbon/human/H
		if(!ishuman(M))
			M.respawn_character()

	//Collect minds and finish respawning
	SSticker.minds.Cut()
	SSticker.collect_minds()
	SSticker.equip_characters()

	GLOB.data_core.medical.Cut()
	GLOB.data_core.general.Cut()
	GLOB.data_core.security.Cut()
	GLOB.data_core.locked.Cut()
	GLOB.data_core.manifest()

	SSticker.transfer_characters()

	delete_antag_items()

	//Choose new gamemode.
	trigger_gamemode_start()

	//Arrive in system
	addtimer(CALLBACK(src, .proc/arrive_in_system, target_system, ftl_start), 180 SECONDS, TIMER_UNIQUE)

/proc/trigger_gamemode_start()
	var/list/datum/game_mode/runnable_modes
	if(GLOB.master_mode == "random" || GLOB.master_mode == "secret")
		runnable_modes = global.config.get_runnable_modes()

		if(GLOB.master_mode == "secret")
			SSticker.hide_mode = 1
			if(GLOB.secret_force_mode != "secret")
				var/datum/game_mode/smode = global.config.pick_mode(GLOB.secret_force_mode)
				if(!smode.can_start())
					message_admins("<span class='notice'>Unable to force secret [GLOB.secret_force_mode]. [smode.required_players] players and [smode.required_enemies] eligible antagonists needed.</span>")
				else
					SSticker.mode = smode

		if(!SSticker.mode)
			if(!runnable_modes.len)
				to_chat(world, "<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")
				return 0
			SSticker.mode = pickweight(runnable_modes)
			if(!SSticker.mode)	//too few roundtypes all run too recently
				SSticker.mode = pick(runnable_modes)

	else
		SSticker.mode = global.config.pick_mode(GLOB.master_mode)
		if(!SSticker.mode.can_start())
			to_chat(world, "<B>Unable to start [SSticker.mode.name].</B> Not enough players, [SSticker.mode.required_players] players and [SSticker.mode.required_enemies] eligible antagonists needed. Reverting to pre-game lobby.")
			qdel(SSticker.mode)
			SSticker.mode = null
			SSjob.ResetOccupations()
			return 0

/obj/structure/overmap/proc/arrive_in_system(datum/star_system/target_system, ftl_start)
	var/list/pulled = list()
	for(var/obj/structure/overmap/SOM in GLOB.overmap_objects)
		if(SOM.z != reserved_z)
			continue
		if(SOM == src)
			continue
		LAZYADD(pulled, SOM)
	target_system.add_ship(src) //Get the system to transfer us to its location.
	for(var/obj/structure/overmap/SOM in pulled)
		target_system.add_ship(SOM)
	SEND_SIGNAL(src, COMSIG_SHIP_ARRIVED) // Let missions know we have arrived in the system
