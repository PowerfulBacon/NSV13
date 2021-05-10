/datum/job/hos
	title = "Security Officer"
	flag = HOS
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Captain")
	department_flag = ENGSEC
	head_announce = list(RADIO_CHANNEL_SECURITY)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ffdddd"
	chat_color = "#D33049"
	exp_type = EXP_TYPE_SECURITY
	exp_type_department = EXP_TYPE_SECURITY

	outfit = /datum/outfit/job/hos
	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

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
				ACCESS_HOS, ACCESS_ARMORY)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	display_order = JOB_DISPLAY_ORDER_HEAD_OF_SECURITY

/datum/outfit/job/hos
	name = "Head of Security"
	jobtype = /datum/job/hos

	id = /obj/item/card/id/silver
	belt = /obj/item/pda/heads/hos
	ears = /obj/item/radio/headset/heads/hos/alt
	uniform = /obj/item/clothing/under/ship/peacekeeper
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/ship/peacekeeper/jacket
	gloves = /obj/item/clothing/gloves/color/black/hos
	head = /obj/item/clothing/head/HoS/beret
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	r_pocket = /obj/item/assembly/flash/handheld
	l_pocket = /obj/item/restraints/handcuffs
	backpack_contents = list(/obj/item/melee/baton/loaded=1, /obj/item/ammo_box/magazine/pistolm9mm/glock,
		/obj/item/gun/ballistic/tazer,  /obj/item/ammo_box/magazine/tazer_cartridge_storage=1) //NSV13 this line

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	duffelbag = /obj/item/storage/backpack/duffelbag/sec
	box = /obj/item/storage/box/security

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/gun/ballistic/automatic/pistol/glock/command/hos, /obj/item/stamp/hos)

/datum/outfit/job/hos/hardsuit
	name = "Head of Security (Hardsuit)"

	mask = /obj/item/clothing/mask/gas/sechailer
	suit = /obj/item/clothing/suit/space/hardsuit/security/hos
	suit_store = /obj/item/tank/internals/oxygen
	backpack_contents = list(/obj/item/melee/baton/loaded=1)

