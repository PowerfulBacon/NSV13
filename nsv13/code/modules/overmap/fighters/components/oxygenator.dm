//Atmos

/obj/item/fighter_component/oxygenator
	name = "Atmospheric Regulator"
	desc = "A device which moderates the conditions inside a fighter, it requires fuel to run."
	icon_state = "oxygenator"
	var/refill_amount = 1 //Starts off really terrible.
	slot = HARDPOINT_SLOT_OXYGENATOR
	weight = 0.5 //Wanna go REALLY FAST? Pack your own O2.
	power_usage = 200

/obj/item/fighter_component/oxygenator/tier2
	name = "Upgraded Atmospheric Regulator"
	tier = 2
	refill_amount = 3
	power_usage = 300

/obj/item/fighter_component/oxygenator/tier3
	name = "Super Oxygenator"
	desc = "A finely tuned atmospheric regulator to be fitted into a fighter which seems to be able to almost magically create oxygen out of nowhere."
	tier = 3
	refill_amount = 10
	power_usage = 400

/obj/item/fighter_component/oxygenator/plasmaman
	name = "Plasmaman Atmospheric Regulator"
	desc = "An atmospheric regulator to be used in fighters, it's been rigged to fill the cabin with a hospitable environment for plasmamen instead of standard oxygen."
	refill_amount = 3
	tier = 4 //unique! but it has to have a sprite to make it obvious that, yknow, this is for plasmemes.

/obj/item/fighter_component/oxygenator/process()
	//Don't waste power on already fine atmos.
	var/obj/structure/overmap/OM = loc
	if(!istype(OM))
		return FALSE
	if(!..())
		return FALSE
	if(OM.cabin_air.return_pressure()+refill_amount >= WARNING_HIGH_PRESSURE-(2*refill_amount))
		return FALSE //No need to add more air to an already pressurized environment

	//Oxygenator just makes sure you have atmosphere. It doesn't care where it comes from.
	OM.cabin_air.set_temperature(T20C)
	//Gives you a little bit of air.
	refill(OM)
	return TRUE

/obj/item/fighter_component/oxygenator/proc/refill(obj/structure/overmap/OM)
	OM.cabin_air.adjust_moles(/datum/gas/oxygen, refill_amount*O2STANDARD)
	OM.cabin_air.adjust_moles(/datum/gas/nitrogen, refill_amount*N2STANDARD)
	OM.cabin_air.adjust_moles(/datum/gas/carbon_dioxide, -refill_amount)

/obj/item/fighter_component/oxygenator/plasmaman/refill(obj/structure/overmap/OM)
	OM.cabin_air.adjust_moles(/datum/gas/plasma, refill_amount*N2STANDARD)
	OM.cabin_air.adjust_moles(/datum/gas/oxygen, -refill_amount)
	OM.cabin_air.adjust_moles(/datum/gas/nitrogen, -refill_amount)
