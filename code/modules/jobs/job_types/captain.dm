/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Nobody")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Nobody"
	selection_color = "#ccccff"
	chat_color = "#FFDC9B"
	exp_type = EXP_TYPE_COMMAND
	exp_type_department = EXP_TYPE_COMMAND

	outfit = /datum/outfit/job/captain

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
				ACCESS_CAPTAIN, ACCESS_MAA, ACCESS_HOS, ACCESS_HOP, ACCESS_CE, ACCESS_VAULT, ACCESS_CMO, ACCESS_QM,
				ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_RD, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_ARMORY)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_DISK_VERIFIER)

	display_order = JOB_DISPLAY_ORDER_CAPTAIN

/datum/job/captain/get_access()
	return get_all_accesses()

/datum/job/captain/announce(mob/living/carbon/human/H)
	..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "Captain [H.real_name] on deck!"))

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	id = /obj/item/card/id/gold
	belt = /obj/item/melee/classic_baton/telescopic/stunsword
	l_pocket = /obj/item/pda/captain
	glasses = /obj/item/clothing/glasses/sunglasses/advanced
	ears = /obj/item/radio/headset/heads/captain/alt
	gloves = /obj/item/clothing/gloves/color/captain
	uniform = /obj/item/clothing/under/ship/officer
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/ship/officer
	head = /obj/item/clothing/head/beret/ship/captain
	backpack_contents = list(/obj/item/melee/classic_baton/police/telescopic=1, /obj/item/station_charter=1)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain

	pda_slot = ITEM_SLOT_LPOCKET

	implants = list(/obj/item/implant/mindshield)
	accessory = /obj/item/clothing/accessory/medal/gold/captain

	chameleon_extras = list(/obj/item/gun/energy/e_gun, /obj/item/stamp/captain)

/datum/outfit/job/captain/hardsuit
	name = "Captain (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/swat/captain
	suit_store = /obj/item/tank/internals/oxygen
