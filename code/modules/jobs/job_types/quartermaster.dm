/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department_head = list("Captain")
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#d7b088"
	chat_color = "#C79C52"
	exp_requirements = 600
	exp_type = EXP_TYPE_SUPPLY
	exp_type_department = EXP_TYPE_SUPPLY

	outfit = /datum/outfit/job/quartermaster

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
				ACCESS_QM, ACCESS_VAULT)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	display_order = JOB_DISPLAY_ORDER_QUARTERMASTER

/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/qm

	belt = /obj/item/pda/quartermaster
	ears = /obj/item/radio/headset/headset_cargo
	uniform = /obj/item/clothing/under/rank/cargo/qm
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses/advanced
	l_hand = /obj/item/clipboard

	chameleon_extras = /obj/item/stamp/qm

