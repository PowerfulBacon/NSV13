
GLOBAL_LIST_EMPTY(antag_items)

/proc/delete_antag_items()
	for(var/obj/item in GLOB.antag_items)
		qdel(item)
