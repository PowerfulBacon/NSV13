
/*
 * Respawns players who are dead.
 */
/obj/structure/overmap/proc/after_jump_completed(datum/star_system/target_system, ftl_start)

	var/static/last_round_end_time = 0

	//Arrive in system
	addtimer(CALLBACK(src, .proc/arrive_in_system, target_system, ftl_start), 180 SECONDS, TIMER_UNIQUE)

	if(world.time > last_round_end_time + 15 MINUTES)
		//Post message
		var/popcount = SSticker.gather_roundend_feedback()
		to_chat(world, "===============================")
		to_chat(world, "<span class='userdanger'>Round Completed</span>")
		to_chat(world, "<span class='danger'>Ship integrity: [popcount["station_integrity"]]%]</span>")
		to_chat(world, "<span class='danger'>Players alive: [popcount[POPCOUNT_SURVIVORS]]</span>")
		to_chat(world, "===============================")
		to_chat(world, "<span class='notice'>THE NEXT ROUND WILL BEGIN IN 180 SECONDS.</span>")
		to_chat(world, "<span class='notice'>Prepare the ship for combat!</span>")
		to_chat(world, "===============================")
		SSticker.display_report(popcount)
	else
		var/popcount = SSticker.gather_roundend_feedback()
		to_chat(world, "===============================")
		to_chat(world, "<span class='danger'>Ship integrity: [popcount["station_integrity"]]%]</span>")
		to_chat(world, "<span class='danger'>Players alive: [popcount[POPCOUNT_SURVIVORS]]</span>")
		to_chat(world, "===============================")
		to_chat(world, "<span class='notice'>THE CURRENT ROUND IS CONTINUING, NO NEW TRAITORS HAVE BEEN CREATED.</span>")
		to_chat(world, "<span class='notice'>Dead players have respawned.</span>")
		to_chat(world, "===============================")

	last_round_end_time = world.time

	//Restart game
	if(world.time > last_round_end_time + 15 MINUTES)
		SSticker.mode.end_gamemode()

	//Respawn people.
	var/list/people_to_respawn = list()
	for(var/mob/M in GLOB.player_list)
		//Create character
		//var/mob/living/carbon/human/H
		if(!ishuman(M))
			people_to_respawn += M.respawn_character()

	//Collect minds and finish respawning
	equip_people(people_to_respawn)

	GLOB.data_core.medical.Cut()
	GLOB.data_core.general.Cut()
	GLOB.data_core.security.Cut()
	GLOB.data_core.locked.Cut()
	GLOB.data_core.manifest()

	SSticker.transfer_characters()

	//Choose new gamemode.
	if(world.time > last_round_end_time + 15 MINUTES)
		delete_antag_items()
		trigger_gamemode_start()

/proc/equip_people(list/people_to_equip)
	for(var/mob/N in people_to_equip)
		var/mob/living/carbon/human/player = N
		player.mind.remove_all_antag_datums()
		if(istype(player) && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role != player.mind.special_role)
				SSjob.EquipRank(N, player.mind.assigned_role, FALSE)
			if(CONFIG_GET(flag/roundstart_traits) && ishuman(player))
				SSquirks.AssignQuirks(player, N.client, TRUE)
		SSjob.SendToLateJoin(player, TRUE)
		CHECK_TICK

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
			to_chat(world, "A new gamemode has started...")

	else
		SSticker.mode = global.config.pick_mode(GLOB.master_mode)
		if(!SSticker.mode.can_start())
			to_chat(world, "<B>Unable to start [SSticker.mode.name].</B> Not enough players, [SSticker.mode.required_players] players and [SSticker.mode.required_enemies] eligible antagonists needed. Reverting to pre-game lobby.")
			qdel(SSticker.mode)
			SSticker.mode = null
			SSjob.ResetOccupations()
			return 0

/obj/structure/overmap/proc/arrive_in_system(datum/star_system/target_system, ftl_start)
	SSstar_system.ships[src]["target_system"] = null
	SSstar_system.ships[src]["current_system"] = target_system
	SSstar_system.ships[src]["last_system"] = target_system
	SSstar_system.ships[src]["from_time"] = 0
	SSstar_system.ships[src]["to_time"] = 0
	SEND_SIGNAL(src, COMSIG_FTL_STATE_CHANGE)
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
	to_chat(world, "<span class='notice'>The next round has started, watch your backs...</span>")
