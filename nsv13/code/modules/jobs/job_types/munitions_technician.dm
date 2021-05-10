/datum/job/munitions_tech
	title = "Munitions Technician"
	flag = MUNITIONS_TECHNICIAN
	department_head = list("Captain")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 8
	spawn_positions = 8
	supervisors = "the Captain"
	selection_color = "#d692a3"
	chat_color = "#ff7f00"
	exp_type_department = EXP_TYPE_MUNITIONS

	outfit = /datum/outfit/job/munitions_tech

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
				ACCESS_MAA)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MUN
	mind_traits = list(TRAIT_MUNITIONS_METABOLISM)
	display_order = JOB_DISPLAY_ORDER_MUNITIONS_TECHNICIAN

/datum/outfit/job/munitions_tech
	name = "Munitions Technician"
	jobtype = /datum/job/munitions_tech

	belt = /obj/item/storage/belt/utility/full/engi
	ears = /obj/item/radio/headset/munitions/munitions_tech
	uniform = /obj/item/clothing/under/rank/munitions_tech
	suit = /obj/item/clothing/suit/ship/munitions_jacket
	head = /obj/item/clothing/head/helmet/decktech
	gloves = /obj/item/clothing/gloves/color/brown
	l_pocket = /obj/item/pda

	backpack = /obj/item/storage/backpack/munitions
	satchel = /obj/item/storage/backpack/satchel/munitions
	duffelbag = /obj/item/storage/backpack/duffelbag/munitions
