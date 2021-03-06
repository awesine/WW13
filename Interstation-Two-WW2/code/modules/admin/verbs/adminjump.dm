/mob/proc/on_mob_jump()
	return

/mob/observer/ghost/on_mob_jump()
	stop_following()

/client/proc/Jump(var/area/A in return_sorted_areas())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		usr.on_mob_jump()
		var/new_location = safepick(get_area_turfs(A))

		if(new_location)
			usr.loc = new_location
			log_admin("[key_name(usr)] jumped to [A]")
			message_admins("[key_name_admin(usr)] jumped to [A]", TRUE)
		else
			alert("Admin jump failed due to missing [A] area turfs.")

	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", TRUE)
		usr.on_mob_jump()
		usr.loc = T

	else
		alert("Admin jumping disabled")
	return

/client/proc/jumptomob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Jump to Mob"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", TRUE)
		if(mob)
			var/mob/A = mob
			var/turf/T = get_turf(M)
			if(T && isturf(T))

				A.on_mob_jump()
				A.loc = T
			else
				A << "This mob is not located in the game world."
	else
		alert("Admin jumping disabled")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if (config.allow_admin_jump)
		if(mob)
			var/mob/A = mob
			A.on_mob_jump()
			A.x = tx
			A.y = ty
			A.z = tz

		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		alert("Admin jumping disabled")

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			src << "No keys found."
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", TRUE)
		usr.on_mob_jump()
		usr.loc = M.loc

	else
		alert("Admin jumping disabled")

/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", TRUE)
		M.on_mob_jump()
		M.loc = get_turf(usr)

	else
		alert("Admin jumping disabled")

var/turf/default_adminzone_turf = null

/client/proc/Goto_adminzone()
	set category = "Ghost"
	set name = "Go To The Admin Zone"

	if(!check_rights(R_MOD))
		return

	log_admin("[key_name(usr)] went to the admin zone")
	message_admins("[key_name_admin(usr)] went to the admin zone", TRUE)

	if (!default_adminzone_turf)
		default_adminzone_turf = locate(90, 92, 3)

	if (default_adminzone_turf)
		if (get_area(default_adminzone_turf).type == /area/prishtina/admin)
			mob.loc = default_adminzone_turf
			return TRUE

	var/area/prishtina/admin/admin_zone = locate() in world
	for (var/turf/T in admin_zone.contents)
		mob.loc = T
		break

	return FALSE


/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name(M)]", TRUE)
		if(M)
			M.on_mob_jump()
			M.loc = get_turf(usr)

	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") in return_sorted_areas()
	if(A)
		if(config.allow_admin_jump)
			M.on_mob_jump()
			M.loc = pick(get_area_turfs(A))


			log_admin("[key_name(usr)] teleported [key_name(M)] to [A]")
			message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)] to [A]", TRUE)
		else
			alert("Admin jumping disabled")
