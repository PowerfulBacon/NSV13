/*Weaponry!
As a rule of thumb, primaries are small guns that take ammo boxes, secondaries are big guns that require big bulky objects to be loaded into them.
Utility modules can be either one of these types, just ensure you set its slot to HARDPOINT_SLOT_UTILITY
*/
/obj/item/fighter_component/primary
	name = "Fuck you"
	slot = HARDPOINT_SLOT_PRIMARY
	fire_mode = FIRE_MODE_PDC
	var/overmap_select_sound = 'nsv13/sound/effects/ship/pdc_start.ogg'
	var/overmap_firing_sounds = list('nsv13/sound/effects/fighters/autocannon.ogg')
	var/accepted_ammo = /obj/item/ammo_box/magazine
	var/obj/item/ammo_box/magazine/magazine = null
	var/list/ammo = list()
	var/burst_size = 1
	var/fire_delay = 0

/obj/item/fighter_component/primary/dump_contents()
	. = ..()
	for(var/atom/movable/AM in .)
		if(AM == magazine)
			magazine = null
			ammo = list()
			playsound(loc, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)

/obj/item/fighter_component/primary/get_ammo()
	return ammo?.len

/obj/item/fighter_component/primary/get_max_ammo()
	return magazine ? magazine.max_ammo : 500 //Default.

/obj/item/fighter_component/primary/load(obj/structure/overmap/target, atom/movable/AM)
	if(!istype(AM, accepted_ammo))
		return FALSE
	magazine?.forceMove(get_turf(target))
	if(!SSmapping.level_trait(loc.z, ZTRAIT_BOARDABLE))
		qdel(magazine) //So bullets don't drop onto the overmap.
	AM.forceMove(src)
	magazine = AM
	ammo = magazine.stored_ammo
	playsound(target, 'nsv13/sound/effects/ship/mac_load.ogg', 100, 1)
	return TRUE

/obj/item/fighter_component/primary/fire(obj/structure/overmap/target)
	var/obj/structure/overmap/fighter/F = loc
	if(!istype(F))
		return FALSE
	if(!ammo.len)
		F.relay('sound/weapons/gun_dry_fire.ogg')
		return FALSE
	var/obj/item/ammo_casing/chambered = ammo[ammo.len]
	var/datum/ship_weapon/SW = F.weapon_types[fire_mode]
	SW.default_projectile_type = chambered.projectile_type
	SW.fire_fx_only(target)
	ammo -= chambered
	qdel(chambered)
	return TRUE

/obj/item/fighter_component/primary/on_install(obj/structure/overmap/target)
	. = ..()
	if(!fire_mode)
		return FALSE
	var/datum/ship_weapon/SW = target.weapon_types[fire_mode]
	SW.overmap_firing_sounds = overmap_firing_sounds
	SW.overmap_select_sound = overmap_select_sound
	SW.burst_size = burst_size
	SW.fire_delay = fire_delay

/obj/item/fighter_component/primary/remove_from(obj/structure/overmap/target)
	. = ..()
	magazine = null
	ammo = list()

/obj/item/fighter_component/primary/cannon
	name = "30mm Vulcan Cannon"
	icon_state = "lightcannon"
	accepted_ammo = /obj/item/ammo_box/magazine/light_cannon
	burst_size = 2
	fire_delay = 0.25 SECONDS

/obj/item/fighter_component/primary/cannon/heavy
	name = "40mm BRRRRTT Cannon"
	icon_state = "heavycannon"
	accepted_ammo = /obj/item/ammo_box/magazine/heavy_cannon
	weight = 2 //Sloooow down there.
	overmap_select_sound = 'nsv13/sound/effects/ship/pdc_start.ogg'
	overmap_firing_sounds = list('nsv13/sound/effects/fighters/BRRTTTTTT.ogg')
	burst_size = 3
	fire_delay = 0.5 SECONDS
