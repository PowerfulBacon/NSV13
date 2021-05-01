/obj/item/fighter_component/fuel_tank
	name = "Fighter Fuel Tank"
	desc = "The fuel tank of a fighter, upgrading this lets your fighter hold more fuel."
	icon_state = "fueltank_tier1"
	var/fuel_capacity = 1000
	slot = HARDPOINT_SLOT_FUEL

/obj/item/fighter_component/fuel_tank/Initialize()
	.=..()
	create_reagents(fuel_capacity, DRAINABLE | AMOUNT_VISIBLE)

/obj/item/fighter_component/fuel_tank/tier2
	name = "Fighter Extended Fuel Tank"
	desc = "A larger fuel tank which allows fighters to stay in combat for much longer"
	icon_state = "fueltank_tier2"
	fuel_capacity = 2500
	tier = 2

/obj/item/fighter_component/fuel_tank/tier3
	name = "Massive Fighter Fuel Tank"
	desc = "A super extended capacity fuel tank, allowing fighters to stay in a warzone for hours on end."
	icon_state = "fueltank_tier3"
	fuel_capacity = 4000
	tier = 3
