// #include <sourcemod>
// #include <sdktools>
// #include <sdktools_functions>
// #include <sdktools_tempents>
// #include <sdktools_sound>
// #include <sdkhooks>
// #include <entity_prop_stocks>
// #include <dhooks>
// #include <smlib>

	// [JBMod] Саня Всё-Тип-Топ<9><[U:1:471132904]><> ent_create weapon_rpg OnCacheInteraction env_screenoverlay,StartOverlays
	

public Action:bot_create_override(client, const String:command[], argc)
{
	int total = 0;
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) == true)
		{
			total = total + 1;
		}
	}
	
	if (total >= 30)
	{
		PrintToConsole(client, "-----------------------------");
		PrintToConsole(client, "Please leave some room for players...");
		PrintToConsole(client, "-----------------------------");
		
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}
	
public Action:prop_physics_create_override(client, const String:command[], argc)
{
	new String:args[4000];
	GetCmdArgString(args, 4000);
	// if (GetUserAdmin(client) != INVALID_ADMIN_ID)
	// {
	PrintToConsoleAll("\t[JBMod] %L %s %s", client, command, args);
	PrintToServer("\t[JBMod] %L %s %s", client, command, args);
	
	// }
	return Plugin_Continue;
}


public Action:ch_createairboat_override(client, const String:command[], argc)
{
	makeVehicle(client, "airboat");
	PrintToConsoleAll("\t[JBMod] %L ch_createairboat", client);
	PrintToServer("\t[JBMod] %L ch_createairboat", client);
	return Plugin_Stop;
}


public Action:ch_createjeep_override(client, const String:command[], argc)
{
	makeVehicle(client, "jeep");
	PrintToConsoleAll("\t[JBMod] %L ch_createjeep", client);
	PrintToServer("\t[JBMod] %L ch_createjeep", client);
	return Plugin_Stop;
}


public Action:ch_createjalopy_override(client, const String:command[], argc)
{
	makeVehicle(client, "jalopy");
	PrintToConsoleAll("\t[JBMod] %L ch_createjalopy", client);
	PrintToServer("\t[JBMod] %L ch_createjalopy", client);
	return Plugin_Stop;
}

public Action:ch_createpod_override(client, const String:command[], argc)
{
	makeVehicle(client, "pod");
	PrintToConsoleAll("\t[JBMod] %L ch_createpod", client);
	PrintToServer("\t[JBMod] %L ch_createpod", client);
	return Plugin_Stop;
}


public Action:ent_create_override(client, const String:command[], argc)
{
	if (client < 1) {return Plugin_Continue;}
	// if(GetUserAdmin(client) != INVALID_ADMIN_ID) {return Plugin_Continue;}
	
	new String:args[4000];
	GetCmdArgString(args, 4000);
	
	new String:class[256];
	GetCmdArg(1, class, sizeof(class));
	
	if (StrEqual(class, "prop_vehicle", bool:false) == bool:true
	|| StrEqual(class, "prop_vehicle_jeep", bool:false) == bool:true
	|| StrEqual(class, "prop_vehicle_airboat", bool:false) == bool:true
	|| StrEqual(class, "prop_vehicle_prisoner_pod", bool:false) == bool:true
	) {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- PLEASE USE ch_createairboat, ch_createjalopy, or ch_createjeep");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
		
	if (!EntityIsWhitelisted(class))
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- ENTITY NOT WHITELISTED: %s", class);
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-- If you believe this is in error");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	if (StrEqual(class, "npc_combine", bool:false) == bool:true
	|| StrEqual(class, "prop_combine_ball", bool:false) == bool:true
	|| StrEqual(class, "env_hudhint", bool:false) == bool:true
	|| StrEqual(class, "game_text", bool:false) == bool:true
	) {
		return Plugin_Stop;
	}
	
	if (StrContains(args, "!player", bool:false) != -1)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- !player is not allowed due to crashes");
		PrintToConsole(client, "-- use !activator instead");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	if (StrContains(args, "modelscale", bool:false) != -1)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- modelscale is banned until i figure out how to fix some crashes");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	// if (StrContains(args, "npc_seagull", bool:false) != -1
	// || StrContains(args, "npc_crow", bool:false) != -1
	// || StrContains(args, "npc_sniper", bool:false) != -1
	// || StrContains(args, "proto_sniper", bool:false) != -1
	// || StrContains(args, "cycler_actor", bool:false) != -1
	// || StrContains(args, "npc_antlionguard", bool:false) != -1
	// || StrContains(args, "env_cubemap", bool:false) != -1
	// || StrContains(args, "npc_barnacle", bool:false) != -1
	// || StrContains(args, "npc_clawscanner", bool:false) != -1
	// || StrContains(args, "npc_cscanner", bool:false) != -1
	// || StrContains(args, "npc_combinegunship", bool:false) != -1
	// || StrContains(args, "npc_helicopter", bool:false) != -1
	// || StrContains(args, "npc_strider", bool:false) != -1
	// || StrContains(args, "npc_fisherman", bool:false) != -1
	// || StrContains(args, "npc_zombie", bool:false) != -1
	// || StrContains(args, "npc_fastzombie_torso", bool:false) != -1
	// || StrContains(args, "npc_turret_floor", bool:false) != -1
	// || StrContains(args, "ichthyosaur", bool:false) != -1)
	// {
		// PrintToConsole(client, "-----------------------------------");
		// PrintToConsole(client, "-- THIS NPC IS BANNED BECAUSE OF TOO MANY SERVER CRASHES");
		// PrintToConsole(client, "-----------------------------------");
		// return Plugin_Stop;
	// }
	
	// if (StrContains(args, "npc_seagull", bool:false) != -1
	// || StrContains(args, "monster_generic", bool:false) != -1
	// || StrContains(args, "env_viewpunch", bool:false) != -1
	// || StrContains(args, "npc_crow", bool:false) != -1
	// || StrContains(args, "point_c", bool:false) != -1
	// || StrContains(args, "point_s", bool:false) != -1
	// || StrContains(args, "grenade_beam", bool:false) != -1 //crash
	// || StrContains(args, "grenade_homer", bool:false) != -1 //crash
	// || StrContains(args, "grenade_beam_chaser", bool:false) != -1 //crash
	// || StrContains(args, "point_servercommand", bool:false) != -1
	// || StrContains(args, "trigger_c", bool:false) != -1
	// || StrContains(args, "npc_sniper", bool:false) != -1
	// || StrContains(args, "weapon_ar1", bool:false) != -1
	// || StrContains(args, "world_items", bool:false) != -1
	// || StrContains(args, "ichthyosaur", bool:false) != -1
	// || StrContains(args, "worldspawn", bool:false) != -1
	// || StrContains(args, "info_player_s", bool:false) != -1
	// || StrContains(args, "sky_camera", bool:false) != -1
	// ) {
		// PrintToConsole(client, "-----------------------------------");
		// PrintToConsole(client, "-- ENTITY NOT ALLOWED - IF THIS MESSAGE APPEARS IN ERROR", command, client);
		// PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		// PrintToConsole(client, "-----------------------------------");
		// return Plugin_Stop;
	// }
		
	if (StrContains(args, "player", bool:false) != -1
	&& StrContains(args, "kill", bool:false) != -1
	) {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- DO NOT TRY TO REMOVE PLAYERS - IF THIS MESSAGE APPEARS IN ERROR");
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	if (StrContains(args, "activator", bool:false) != -1
	&& StrContains(args, "kill", bool:false) != -1
	) {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- DO NOT TRY TO REMOVE PLAYERS - IF THIS MESSAGE APPEARS IN ERROR");
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	if (StrContains(args, "StartOverlays", bool:false) != -1) {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- GLOBAL OVERLAYS ARE TEMPORARILY DISABLED");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	

	

	new Float:endpos[3] = {0.0,0.0,0.0};
	jb_getAimTargetHit(client, endpos);
	
	if (TR_PointOutsideWorld(endpos) == true)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- cannot create entities in the void");
		PrintToConsole(client, "-----------------------------------");
		return Plugin_Stop;
	}	
	
	new myfire = CreateEntityByName(class);
	
	if (GetUserAdmin(client) == INVALID_ADMIN_ID)
	{
		for (int i=2; i <= argc; i=i+1)
		{
			new String:argument[256];
			GetCmdArg(i, argument, sizeof(argument));
			
			if (StrContains(argument, "*", false) != -1
			&& StrContains(argument, "kill", false) != -1)
			{
				PrintToConsole(client, "-----------------------------------");
				PrintToConsole(client, "-- what are you doing?!");
				PrintToConsole(client, "-----------------------------------");
				
				PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
				return Plugin_Stop;
			}
		}
	}
	
	if (argc % 2 > 0)
	{
		for (int i = 2; i <= argc; i=i+2)
		{
			new String:key[256];
			GetCmdArg(i, key, sizeof(key));
			
			new String:val[256];
			GetCmdArg(i+1, val, sizeof(val));
			
			float valFloat;
			int valInt;
			bool isValFloat = GetCmdArgFloatEx(i+1, valFloat);
			bool isValInt = GetCmdArgIntEx(i+1, valInt);
			
			DispatchKeyValue(myfire, key, val);
			
			if (StrEqual(key, "itemclass", false) == true)
			{
				if (
				StrContains(val, "npc", false) != -1
				|| StrContains(val, "point_", false) != -1
				|| StrContains(val, "func_", false) != -1
				|| StrContains(val, "item_item", false) != -1
				// || StrContains(val, "prop_", false) != -1
				|| !EntityIsWhitelisted(val))
				{
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- ENTITY NOT WHITELISTED: %s", val);
					PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
					PrintToConsole(client, "-- If you believe this is in error");
					PrintToConsole(client, "-----------------------------------");
					
					PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
					return Plugin_Stop;
				}
			}
			else if (StrEqual(key, "modelscale", false) == true)
			{
				if (StrEqual(val, "") == true || sizeof(val) == 0) {
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- MODELSCALE OUT OF RANGE (0.01 to 100)");
					PrintToConsole(client, "-----------------------------------");
					return Plugin_Stop;
				}
				
				if ((!isValFloat && !isValInt) || (argc % 2 == 0) ) {
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- MODELSCALE OUT OF RANGE (0.01 to 100)");
					PrintToConsole(client, "-----------------------------------");
					
					PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
					return Plugin_Stop;
				}
				
				if (isValFloat && (valFloat > 100.0 || valFloat < 0.1)) {
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- MODELSCALE OUT OF RANGE (0.01 to 100)");
					PrintToConsole(client, "-----------------------------------");
					
					PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
					return Plugin_Stop;
				}
				if (isValInt && (valInt > 100 || valInt < 1)) {
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- MODELSCALE OUT OF RANGE (0.01 to 100)");
					PrintToConsole(client, "-----------------------------------");
					
					PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
					return Plugin_Stop;
				}
				
				char err[256];
				if (SimpleRegexMatch(val, "[^.0-9]", PCRE_CASELESS, err, sizeof(err) != -1))
				{
					PrintToConsole(client, "-----------------------------------");
					PrintToConsole(client, "-- MODELSCALE OUT OF RANGE (0.01 to 100)");
					PrintToConsole(client, "-----------------------------------");
					
					PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
					return Plugin_Stop;
				}
			}
		}
	} else {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- ERROR: EVEN AMOUNT OF ARGUMENTS (MUST BE UNEVEN)");
		PrintToConsole(client, "-----------------------------------");
		
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	// if (HasEntProp(myfire, Prop_Send, "m_bFadeCorpse"))
	// {
		// SetEntProp(myfire, Prop_Send, "m_bFadeCorpse", 1);
		// SetEntProp(myfire, Prop_Data, "m_bFadeCorpse", 1);
	// }
	if (StrContains(class, "npc_", bool:false) != -1)
	{
		Entity_AddSpawnFlags(myfire, 512); //new fade corpse method
	}
	TeleportEntity(myfire, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0} );
	
	DispatchSpawn(myfire);
	
	float normal[3];
	TR_GetPlaneNormal(INVALID_HANDLE, normal);	
	
	if( HasEntProp(myfire, Prop_Data, "m_vecMins") )
	{
		float vStart[3], vEnd[3];
		float oobcenter[3];

		GetEntPropVector(myfire, Prop_Data, "m_vecMins", vStart);
		GetEntPropVector(myfire, Prop_Data, "m_vecMaxs", vEnd);
		// PrintToChat(client, "Width: %.2f, Length: %.2f, Heigth: %.2f", FloatAbs(vStart[0] - vEnd[0]), FloatAbs(vStart[1] - vEnd[1]), FloatAbs(vStart[2] - vEnd[2]));
		
		oobcenter[0] = (vStart[0] + vEnd[0]) / 2.0;
		oobcenter[1] = (vStart[1] + vEnd[1]) / 2.0;
		oobcenter[2] = (vStart[2] + vEnd[2]) / 2.0;
		
		ScaleVector(normal, 32000.0);	
		normal[0] = Math_FClamp(normal[0], vStart[0], vEnd[0]);
		normal[1] = Math_FClamp(normal[1], vStart[1], vEnd[1]);
		normal[2] = Math_FClamp(normal[2], vStart[2], vEnd[2]);
		
		normal[0] = normal[0] - (oobcenter[0] * 2.0);
		normal[1] = normal[1] - (oobcenter[1] * 2.0);
		normal[2] = normal[2] - (oobcenter[2] * 2.0);
	}
	
	AddVectors(endpos, normal, endpos);
	TeleportEntity(myfire, endpos, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0} );
	
	ActivateEntity(myfire);
	
	pp_setOwner(myfire, client);
	
	// if (GetUserAdmin(client) != INVALID_ADMIN_ID)
	// {
	PrintToConsoleAll("\t[JBMod] %L %s %s", client, command, args);
	PrintToServer("\t[JBMod] %L %s %s", client, command, args);
	// }

	return Plugin_Stop;
}


public Action:cmd_cooldown(client, const String:command[], argc)
{
	if (client < 1) {return Plugin_Continue;}
	
	MoveType movetype = GetEntityMoveType(client);
	
	if (StrEqual(command, "noclip")) {
		if (movetype == MOVETYPE_WALK) {
			SetEntityMoveType(client, MOVETYPE_NOCLIP);
			return Plugin_Stop;
		} else {
			SetEntityMoveType(client, MOVETYPE_WALK);
			return Plugin_Stop;
		}
	}
	
	// if(GetUserAdmin(client) != INVALID_ADMIN_ID) {return Plugin_Continue;}
	
	new String:args[4000];
	GetCmdArgString(args, 4000);
	
	++g_totalcommands[client];
	if (GetUserAdmin(client) == INVALID_ADMIN_ID && g_totalcommands[client] > 30) {
		BanClient(client, 5, BANFLAG_AUTO, "Flooding", "Stop flooding");

		return Plugin_Stop;
	}
	
	if (StrContains(command, "ent_remove", bool:false) != -1)
	{
		if (g_next_remove[client] <= 0) {
			PrintToConsole(client, "Blocked for flooding");
			return Plugin_Stop;
		}
		
		--g_next_remove[client];
	}
	
	if (StrContains(command, "ent_fire", bool:false) != -1)
	{
		if (g_next_entfire[client] <= 0) {
			PrintToConsole(client, "Blocked for flooding");
			return Plugin_Stop;
		}
		
		--g_next_entfire[client];
	}
	
	if (StrContains(command, "ch_createjeep", bool:false) != -1
	|| StrContains(command, "ch_createairboat", bool:false) != -1
	|| StrContains(command, "ch_createjalopy ", bool:false) != -1)
	{
		if (g_next_vehicle[client] <= 0) {
			PrintToConsole(client, "Blocked for flooding");
			return Plugin_Stop;
		}
		
		--g_next_vehicle[client];
	}

	if (StrContains(command, "give", bool:false) != -1
	|| StrContains(command, "impulse", bool:false) != -1
	|| StrContains(command, "ent_create", bool:false) != -1
	|| StrContains(command, "npc_create", bool:false) != -1
	|| StrContains(command, "ch_createairboat", bool:false) != -1
	|| StrContains(command, "ch_createjeep", bool:false) != -1
	|| StrContains(command, "ch_createjalopy", bool:false) != -1
	|| StrContains(command, "prop_physics_create", bool:false) != -1)
	{
		if (g_last_impulse[client] <= 0) {
			PrintToConsole(client, "Blocked for flooding");
			return Plugin_Stop;
		}
		
		--g_last_impulse[client];
	}
	
	if (StrContains(command, "activator", bool:false) != -1 && StrContains(command, "kill", bool:false) != -1)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- DO NOT TRY TO REMOVE PLAYERS - IF THIS MESSAGE APPEARS IN ERROR");
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-----------------------------------");
		PrintToConsoleAll("\t[JBMod] [BLOCKED] %L %s %s", client, command, args);
		return Plugin_Stop;
	}
	
	return Plugin_Continue;
}


public Action:fix_entremove(client, const String:command[], argc)
{
	if (client == 0) {return Plugin_Continue;}
	
	new String:args[4000];
	GetCmdArgString(args, 4000);
	
	if (argc < 1)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- ONLY ONE ARGUMENT IS ALLOWED FOR ent_remove", command, client);
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-- (I MIGHT WHITELIST IT)");
		PrintToConsole(client, "-----------------------------------");
		return Plugin_Stop;
	}
	
	new String:arg1[256];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	if (
	   StrContains(arg1, "sky_camera", bool:false) != -1
	|| StrContains(arg1, "func_button", bool:false) != -1
	|| StrContains(arg1, "player", bool:false) != -1
	|| StrContains(arg1, "env_fog_controller", bool:false) != -1
	|| StrContains(arg1, "info_ladder_dismount", bool:false) != -1
	|| StrContains(arg1, "light_environment", bool:false) != -1
	|| StrContains(arg1, "world_items", bool:false) != -1
	|| StrContains(arg1, "info_node", bool:false) != -1
	|| StrContains(arg1, "point_template", bool:false) != -1
	|| StrContains(arg1, "point_c", bool:false) != -1
	|| StrContains(arg1, "point_s", bool:false) != -1
	|| StrContains(arg1, "trigger_c", bool:false) != -1
	|| StrContains(arg1, "info_player", bool:false) != -1
	|| StrContains(arg1, "npc_combinegunship", bool:false) != -1
	|| StrContains(arg1, "trigger_", bool:false) != -1
	|| StrContains(arg1, "func_useable", bool:false) != -1
	|| StrContains(arg1, "water_l", bool:false) != -1
	// || StrContains(arg1, "trigger_multiple", bool:false) != -1
	|| StrContains(arg1, "viewmodel", bool:false) != -1
	// || StrContains(arg1, "npc_", bool:false) != -1
	|| StrContains(arg1, "worldsp", bool:false) != -1)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- CANNOT REMOVE (error #8941844) - IF THIS MESSAGE APPEARS IN ERROR", command, client);
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-- (I MIGHT WHITELIST IT)");
		PrintToConsole(client, "-----------------------------------");
		return Plugin_Stop;
	}
	
	new target = StringToInt(arg1);
	if ((target >= 1 && target <= MaxClients)
	|| (target >= 1 && target <= MaxClients && StrContains(arg1, "e", bool:false) != -1))
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- COMMAND NOT ALLOWED: ENT_REMOVE (error #8941844) - IF THIS MESSAGE APPEARS IN ERROR", command, client);
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-- (I MIGHT WHITELIST IT)");
		PrintToConsole(client, "-----------------------------------");
		return Plugin_Stop;
	}

	// if (StrEqual(command, "ent_remove_all", bool:false))
	// {		
	PrintToConsoleAll("\t[JBMod] %L %s %s", client, command, args);
	PrintToServer("\t[JBMod] %L %s %s", client, command, args);
	// }

	return Plugin_Continue;
}


// public Action:cmd_createfirewall(client, const String:command[], argc)
// {
	// new String:args[4000];
	// GetCmdArgString(args, 4000);
	
	
	// PrintToConsole(client, "%i modulo 2 = %i", argc, argc % 2);
	
	// if (argc % 2 > 0) {
		// PrintToConsole(client, "uneven amt of arguments, this is ok!");
	// }
		
	// PrintToConsole(client, "what i understood is:");
	
	// for (new i = 2; i <= argc; i=i+2)
	// {
		// new String:arg1[256];
		// GetCmdArg(i, arg1, sizeof(arg1));
		
		// PrintToConsole(client, "%i = %s", i, arg1);
		
		// if (i+1 <= argc)
		// {
			// new String:nextarg[256];
			// GetCmdArg(i+1, nextarg, sizeof(nextarg));
			
			
			// PrintToConsole(client, "~%s~ = ~%s~", arg1, nextarg);
		// }
		
	// }
	
	// return Plugin_Continue;
// }


public Action cmd_removebymodel(int client, int argc)
{
	new String:args[512];
	GetCmdArgString(args, 512);

	for (new i=1; i<=2048; i++)
	{
		if (IsValidEntity(i) && IsEntNetworkable(i))
		{
			new String:model[512];
			Entity_GetModel(i, model, 512);
			
			if (StrContains(model, args, bool:true) != -1)
			{
				jb_RemoveEntity(i);
			}
		}
	}	
	return Plugin_Handled;
}


public Action:addcheat(args)
{
    if (args < 1)
    {
        return Plugin_Handled;
    }
    new String:arg1[256];
    GetCmdArg(1, arg1, sizeof(arg1));

    new Handle:hConVar = FindConVar(arg1);
    if (hConVar != INVALID_HANDLE)
    {
        new flags = GetConVarFlags(hConVar);
        flags |= FCVAR_CHEAT;
        SetConVarFlags(hConVar, flags);
    }
    else
    {
        new flags = GetCommandFlags(arg1);
        if (flags == INVALID_FCVAR_FLAGS)
        {
            return Plugin_Handled;
        }
        flags |= FCVAR_CHEAT;
        SetCommandFlags(arg1, flags);
    }
    return Plugin_Handled;
}


public Action:removecheat(args)
{
    if (args < 1)
    {
        return Plugin_Handled;
    }
    new String:arg1[256];
    GetCmdArg(1, arg1, sizeof(arg1));

    new Handle:hConVar = FindConVar(arg1);
    if (hConVar != INVALID_HANDLE)
    {
        new flags = GetConVarFlags(hConVar);
        flags &= ~FCVAR_CHEAT;
        SetConVarFlags(hConVar, flags);
    }
    else
    {
        new flags = GetCommandFlags(arg1);
        if (flags == INVALID_FCVAR_FLAGS)
        {
            return Plugin_Handled;
        }
        flags &= ~FCVAR_CHEAT;
        SetCommandFlags(arg1, flags);
    }
    return Plugin_Handled;
}

