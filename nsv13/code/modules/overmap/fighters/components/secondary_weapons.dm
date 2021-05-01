/obj/item/fighter_component/secondary
	name = "Fuck you"
	slot = HARDPOINT_SLOT_SECONDARY
	fire_mode = FIRE_MODE_TORPEDO
	var/overmap_firing_sounds = list(
		'nsv13/sound/effects/ship/torpedo.ogg',
		'nsv13/sound/effects/ship/freespace2/m_shrike.wav',
		'nsv13/sound/effects/ship/freespace2/m_stiletto.wav',
		'nsv13/sound/effects/ship/freespace2/m_tsunami.wav',
		'nsv13/sound/effects/ship/freespace2/m_wasp.wav')
	var/overmap_select_sound = 'nsv13/sound/effects/ship/reload.ogg'
	var/accepted_ammo = /obj/item/ship_weapon/ammunition/missile
	var/list/ammo = list()
	var/max_ammo = 3
	var/burst_size = 1 //Cluster torps...UNLESS?
	var/fire_delay = 0.25 SECONDS

/obj/item/fighter_component/secondary/dump_contents()
	. = ..()
	for(var/atom/movable/AM in .)
		if(AM in ammo)
			ammo -= AM
			playsound(loc, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)

/obj/item/fighter_component/secondary/get_ammo()
	return ammo.len

/obj/item/fighter_component/secondary/get_max_ammo()
	return max_ammo

/obj/item/fighter_component/secondary/on_install(obj/structure/overmap/target)
	. = ..()
	if(!fire_mode)
		return FALSE
	var/datum/ship_weapon/SW = target.weapon_types[fire_mode]
	SW.overmap_firing_sounds = overmap_firing_sounds
	SW.overmap_select_sound = overmap_select_sound
	SW.burst_size = burst_size
	SW.fire_delay = fire_delay

/obj/item/fighter_component/secondary/remove_from(obj/structure/overmap/target)
	. = ..()
	ammo = list()

//Todo: make fighters use these.
/obj/item/fighter_component/secondary/ordnance_launcher
	name = "Fighter Missile Rack"
	desc = "A huge fighter missile rack capable of deploying missile based weaponry."
	icon_state = "missilerack"

/obj/item/fighter_component/secondary/ordnance_launcher/tier2
	name = "Upgraded Fighter Missile Rack"
	tier = 2
	max_ammo = 5

/obj/item/fighter_component/secondary/ordnance_launcher/tier3
	name = "A-11 'Spacehog' Cluster-Freedom Launcher"
	tier = 3
	max_ammo = 15
	weight = 1
	burst_size = 2
	fire_delay = 0.10 SECONDS

//Specialist item for the superiority fighter.
/obj/item/fighter_component/secondary/ordnance_launcher/railgun
	name = "Fighter Railgun"
	desc = "A scaled down railgun designed for use in fighters."
	icon_state = "railgun"
	weight = 1
	accepted_ammo = /obj/item/ship_weapon/ammunition/railgun_ammo
	overmap_firing_sounds = list('nsv13/sound/effects/ship/railgun_fire.ogg')
	burst_size = 1
	fire_delay = 0.2 SECONDS
	max_ammo = 10
	tier = 1

/obj/item/fighter_component/secondary/ordnance_launcher/torpedo
	name = "Fighter Torpedo Launcher"
	desc = "A heavy torpedo rack which allows fighters to fire torpedoes at targets"
	icon_state = "torpedorack"
	accepted_ammo = /obj/item/ship_weapon/ammunition/torpedo
	max_ammo = 2
	weight = 1

/obj/item/fighter_component/secondary/ordnance_launcher/torpedo/tier2
	name = "Enhanced Torpedo Launcher"
	tier = 2
	max_ammo = 4

/obj/item/fighter_component/secondary/ordnance_launcher/torpedo/tier3
	name = "FR33-8IRD Torpedo Launcher"
	desc = "A massive torpedo launcher capable of deploying enough ordnance to level several small, oil-rich nations."
	tier = 3
	max_ammo = 10
	weight = 2
	burst_size = 2

/obj/item/fighter_component/secondary/ordnance_launcher/load(obj/structure/overmap/target, atom/movable/AM)
	if(!istype(AM, accepted_ammo))
		return FALSE
	if(ammo.len >= max_ammo)
		return FALSE
	AM.forceMove(src)
	ammo += AM
	playsound(target, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)
	return TRUE

/obj/item/fighter_component/secondary/ordnance_launcher/fire(obj/structure/overmap/target)
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return FALSE
	if(!ammo.len)
		F.relay('sound/weapons/gun_dry_fire.ogg')
		return FALSE
	var/proj_type = null //If this is true, we've got a launcher shipside that's been able to fire.
	var/proj_speed = 1
	var/obj/item/ship_weapon/ammunition/americagobrr = pick_n_take(ammo)
	proj_type = americagobrr.projectile_type
	proj_speed = istype(americagobrr.projectile_type, /obj/item/projectile/guided_munition/missile) ? 5 : 1
	qdel(americagobrr)
	if(proj_type)
		var/sound/chosen = pick('nsv13/sound/effects/ship/torpedo.ogg','nsv13/sound/effects/ship/freespace2/m_shrike.wav','nsv13/sound/effects/ship/freespace2/m_stiletto.wav','nsv13/sound/effects/ship/freespace2/m_tsunami.wav','nsv13/sound/effects/ship/freespace2/m_wasp.wav')
		F.relay_to_nearby(chosen)
		if(proj_type == /obj/item/projectile/guided_munition/missile/dud) //Refactor this to something less trash sometime I guess
			F.fire_projectile(proj_type, target, homing = FALSE, speed=proj_speed, explosive = TRUE)
		else
			F.fire_projectile(proj_type, target, homing = TRUE, speed=proj_speed, explosive = TRUE)
	return TRUE
