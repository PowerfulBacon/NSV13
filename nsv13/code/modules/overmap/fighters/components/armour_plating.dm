/obj/item/fighter_component/armour_plating
	name = "Durasteel Armour Plates"
	desc = "A set of armour plates which can afford basic protection to a fighter, however heavier plates may slow you down"
	icon_state = "armour"
	slot = HARDPOINT_SLOT_ARMOUR
	weight = 1
	obj_integrity = 250
	max_integrity = 250
	armor = list("melee" = 50, "bullet" = 40, "laser" = 80, "energy" = 50, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 80) //Armour's pretty tough.

//Sometimes you need to repair your physical armour plates.
/obj/item/fighter_component/armour_plating/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(obj_integrity >= max_integrity)
		to_chat(user, "<span class='notice'>[src] isn't in need of repairs.</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You start welding some dents out of [src]...</span>")
	if(I.use_tool(src, user, 4 SECONDS, volume=100))
		to_chat(user, "<span class='notice'>You weld some dents out of [src].</span>")
		obj_integrity += min(10, max_integrity-obj_integrity)
		return TRUE

/obj/item/fighter_component/armour_plating/on_install(obj/structure/overmap/target)
	..()
	target.max_integrity = initial(target.max_integrity)*tier

/obj/item/fighter_component/armour_plating/remove_from(obj/structure/overmap/target, due_to_damage)
	..()
	if(due_to_damage)
		return //We don't reset our health if the plating was destroyed due to hits, or the increase would be useless. It DOES get reset once we install new armor, though.
	target.max_integrity = initial(target.max_integrity)
	//Remove any overheal.
	target.obj_integrity = CLAMP(target.obj_integrity, 0, target.max_integrity)

/obj/item/fighter_component/armour_plating/tier2
	name = "Ultra Heavy Fighter Armour"
	desc = "An extremely thick and heavy set of armour plates. Guaranteed to weigh you down, but it'll keep you flying through brasil itself."
	tier = 2
	weight = 2
	obj_integrity = 450
	max_integrity = 450

/obj/item/fighter_component/armour_plating/tier3
	name = "Nanocarbon Armour Plates"
	desc = "A lightweight set of ablative armour which balances speed and protection at the cost of the average GDP of most third world countries."
	tier = 3
	weight = 1.25
	obj_integrity = 300
	max_integrity = 300
