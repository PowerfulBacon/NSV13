/obj/item/fighter_component/battery
	name = "Fighter Battery"
	icon_state = "battery"
	slot = HARDPOINT_SLOT_BATTERY
	active = FALSE
	var/charge = 10000
	var/maxcharge = 10000
	var/self_charge = FALSE //TODO! Engine powers this.

/obj/item/fighter_component/battery/process()
	if(self_charge)
		give(1000)

/obj/item/fighter_component/battery/proc/give(amount)
	if(charge >= maxcharge)
		return FALSE
	charge += amount
	charge = CLAMP(charge, 0, maxcharge)

/obj/item/fighter_component/battery/proc/use_power(amount)
	if(!active)
		return FALSE
	charge -= amount
	charge = CLAMP(charge, 0, maxcharge)
	if(charge <= 0)
		var/obj/structure/overmap/fighter/F = loc
		if(!istype(F))
			return FALSE
		if(active)
			F.set_master_caution(TRUE)
			active = FALSE
	return charge > 0

/obj/item/fighter_component/battery/tier2
	name = "Upgraded Fighter Battery"
	tier = 2
	charge = 20000
	maxcharge = 20000

/obj/item/fighter_component/battery/tier3
	name = "Mega Fighter Battery"
	desc = "An electrochemical cell capable of holding a good amount of charge for keeping the fighter's radio on for longer periods without an engine."
	tier = 3
	charge = 40000
	maxcharge = 40000
