/obj/item/fighter_component/canopy
	name = "Glass canopy"
	desc = "A fighter canopy made of standard glass, it's extremely fragile and is so cheaply produced that it serves as little less than a windshield."
	icon_state = "canopy"
	obj_integrity = 100 //Pretty fragile, don't break it you dumblet
	max_integrity = 100
	slot = HARDPOINT_SLOT_CANOPY
	weight = 0.25 //Real pilots just wear pilot goggles and strip out their canopy.
	tier = 0.5

/obj/item/fighter_component/canopy/reinforced
	name = "Reinforced Glass Canopy"
	desc = "A glass fighter canopy that's designed to maintain atmospheric pressure inside of a fighter, this one's pretty robust."
	obj_integrity = 200
	max_integrity = 200
	tier = 1
	weight = 0.5

/obj/item/fighter_component/canopy/tier2
	name = "Nanocarbon glass canopy"
	desc = "A glass fighter canopy that's designed to maintain atmospheric pressure inside of a fighter, this one's very robust."
	obj_integrity = 350
	max_integrity = 350
	tier = 2
	weight = 0.35

/obj/item/fighter_component/canopy/tier3
	name = "Plasma glass canopy"
	desc = "A glass fighter canopy that's designed to maintain atmospheric pressure inside of a fighter, this one's exceptionally robust."
	obj_integrity = 450
	max_integrity = 450
	tier = 3
	weight = 0.55
