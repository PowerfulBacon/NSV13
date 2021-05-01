/obj/item/fighter_component/engine
	name = "Fighter engine"
	desc = "A mighty engine capable of propelling small spacecraft to high speeds."
	icon_state = "engine"
	slot = HARDPOINT_SLOT_ENGINE
	active = FALSE
	var/rpm = 0
	var/flooded = FALSE

/obj/item/fighter_component/engine/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(!flooded)
		return
	to_chat(user, "<span class='notice'>You start to purge [src] of its flooded fuel.</span>")
	if(do_after(user, 10 SECONDS, target=src))
		flooded = FALSE
		shake_animation()

/obj/item/fighter_component/engine/proc/active()
	return (active && obj_integrity > 0 && rpm >= ENGINE_RPM_SPUN && !flooded)

/obj/item/fighter_component/engine/process()
	var/obj/structure/overmap/fighter/F = loc
	var/obj/item/fighter_component/apu/APU = F.loadout.get_slot(HARDPOINT_SLOT_APU)
	if(!APU?.fuel_line && rpm > 0)
		rpm -= 1000 //Spool down the engine.
		if(rpm <= 0)
			playsound(loc, 'nsv13/sound/effects/ship/rcs.ogg', 100, TRUE)
			loc.visible_message("<span class='userdanger'>[src] fizzles out!</span>")
			rpm = 0
			F.stop_relay(CHANNEL_SHIP_ALERT)
			active = FALSE
			return FALSE
	if(!istype(F))
		return FALSE
	if(rpm > 3000)
		var/obj/item/fighter_component/battery/B = F.loadout.get_slot(HARDPOINT_SLOT_BATTERY)
		B.give(500*tier)
	if(!active())
		return FALSE

/obj/item/fighter_component/engine/proc/apu_spin(amount)
	if(flooded)
		loc.visible_message("<span class='warning'>[src] sputters uselessly.</span>")
		return
	rpm += amount
	rpm = CLAMP(rpm, 0, ENGINE_RPM_SPUN)

/obj/item/fighter_component/engine/proc/try_start()
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return FALSE
	if(rpm >= ENGINE_RPM_SPUN-200) //You get a small bit of leeway.
		active = TRUE
		rpm = ENGINE_RPM_SPUN
		playsound(loc, 'nsv13/sound/effects/fighters/startup.ogg', 100, FALSE)
		F.relay('nsv13/sound/effects/fighters/cockpit.ogg', "<span class='warning'>You hear a loud noise as [F]'s engine kicks in.</span>", loop=TRUE, channel = CHANNEL_SHIP_ALERT)
		return
	else
		playsound(loc, 'sound/machines/clockcult/steam_whoosh.ogg', 100, TRUE)
		loc.visible_message("<span class='warning'>[src] sputters slightly.</span>")
		if(prob(20)) //Don't try and start a not spun engine, flyboys.
			playsound(loc, 'nsv13/sound/effects/ship/rcs.ogg', 100, TRUE)
			loc.visible_message("<span class='userdanger'>[src] violently fizzles out!.</span>")
			F.set_master_caution(TRUE)
			rpm = 0
			flooded = TRUE
			active = FALSE

/obj/item/fighter_component/engine/tier2
	name = "Souped up fighter engine"
	desc = "Born to zoom, forced to oom"
	tier = 2

/obj/item/fighter_component/engine/tier3
	name = "Boringheed Marty V12 Super Giga Turbofan Space Engine"
	desc = "An engine which allows a fighter to exceed the legal speed limit in most jurisdictions."
	tier = 3

/obj/item/fighter_component/engine/on_install(obj/structure/overmap/fighter/target)
	..()
	target.speed_limit = initial(target.speed_limit)*tier
	target.forward_maxthrust = initial(target.forward_maxthrust)*tier
	target.backward_maxthrust = initial(target.backward_maxthrust)*tier
	target.side_maxthrust = initial(target.side_maxthrust)*tier
	target.max_angular_acceleration = initial(target.max_angular_acceleration)*tier
	for(var/slot in target.loadout.equippable_slots)
		var/obj/item/fighter_component/FC = target.loadout.get_slot(slot)
		FC?.apply_drag(target)

/obj/item/fighter_component/engine/remove_from(obj/structure/overmap/target)
	..()
	//No engines? No movement.
	target.speed_limit = 0
	target.forward_maxthrust = 0
	target.backward_maxthrust = 0
	target.side_maxthrust = 0
	target.max_angular_acceleration = 0
