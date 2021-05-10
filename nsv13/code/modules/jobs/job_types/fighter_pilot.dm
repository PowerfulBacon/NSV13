/datum/job/fighter_pilot
	title = "Fighter Pilot"
	flag = FIGHTER_PILOT
	department_head = list("Captain")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Captain"
	selection_color = "#d692a3"
	chat_color = "#2681a5"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_MUNITIONS

	outfit = /datum/outfit/job/fighter_pilot

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_SEC_RECORDS, ACCESS_BRIG, ACCESS_BRIGPHYS, ACCESS_FORENSICS_LOCKERS, ACCESS_COURT,
	            ACCESS_MEDICAL, ACCESS_GENETICS, ACCESS_MORGUE,
	            ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_CHEMISTRY, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MAINT_TUNNELS,
	            ACCESS_EXTERNAL_AIRLOCKS,
	            ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_HEADS,
	            ACCESS_TECH_STORAGE, ACCESS_CHAPEL_OFFICE, ACCESS_ATMOSPHERICS, ACCESS_KITCHEN,
	            ACCESS_BAR, ACCESS_JANITOR, ACCESS_CREMATORIUM, ACCESS_ROBOTICS, ACCESS_CARGO, ACCESS_CONSTRUCTION, ACCESS_AUX_BASE,
	            ACCESS_HYDROPONICS, ACCESS_LIBRARY, ACCESS_LAWYER, ACCESS_VIROLOGY, ACCESS_SURGERY,
	            ACCESS_THEATRE, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING, ACCESS_WEAPONS,
				ACCESS_MECH_MINING, ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MECH_MEDICAL,
	            ACCESS_MINING_STATION, ACCESS_XENOBIOLOGY, ACCESS_RC_ANNOUNCE,
	            ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM, ACCESS_MINISAT, ACCESS_NETWORK, ACCESS_CLONING,
	            ACCESS_MUNITIONS, ACCESS_MUNITIONS_STORAGE, ACCESS_FIGHTER, ACCESS_FL, ACCESS_MINING_ENGINEERING, ACCESS_MINING_BRIDGE,
				//NOT REQUIRED STUFF
				)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MUN
	mind_traits = list(TRAIT_MUNITIONS_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_FIGHTER_PILOT

/datum/outfit/job/fighter_pilot
	name = "Fighter Pilot"
	jobtype = /datum/job/fighter_pilot

	ears = /obj/item/radio/headset/munitions/pilot
	uniform = /obj/item/clothing/under/ship/pilot
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/beret/ship/pilot

	backpack = /obj/item/storage/backpack/munitions
	satchel = /obj/item/storage/backpack/satchel/munitions
	duffelbag = /obj/item/storage/backpack/duffelbag/munitions

/datum/outfit/job/fighter_pilot/flight_ready
	name = "Fighter Pilot - Flight Ready"
	jobtype = /datum/job/fighter_pilot
	suit = /obj/item/clothing/suit/space/hardsuit/pilot //placeholder
	mask = /obj/item/clothing/mask/breath //placeholder
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
