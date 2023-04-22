
public Action:command_motdstream(client, args)
{
    if (args < 1)
    {
        ReplyToCommand(client, "[SM] Usage: sm_motd_stream <#userid|name> <#isURL 1|0> <string>");
        return Plugin_Handled;
    }

    new String:arg[256];
    new String:isURLa[256];
    new String:stream[256];
    GetCmdArg(1, arg, sizeof(arg));
    GetCmdArg(2, isURLa, sizeof(isURLa));
    GetCmdArg(3, stream, sizeof(stream));
    new isURLb = StringToInt(isURLa);

    new String:target_name[MAX_TARGET_LENGTH];
    new target_list[MAXPLAYERS], target_count, bool:tn_is_ml;

    if ((target_count = ProcessTargetString(
            arg,
            client,
            target_list,
            MAXPLAYERS,
            COMMAND_FILTER_ALIVE,
            target_name,
            sizeof(target_name),
            tn_is_ml)) <= 0)
    {
        ReplyToTargetError(client, target_count);
        return Plugin_Handled;
    }

    for (new i = 0; i < target_count; i++)
    {
        if (isURLb)
        {
            ShowMOTDPanel(target_list[i], "SteamPage", stream, MOTDPANEL_TYPE_URL);
        }
        else
        {
            ShowMOTDPanel(target_list[i], "SteamPage", stream, MOTDPANEL_TYPE_TEXT);
        }
    }
    return Plugin_Handled;
}


public Action:cmd_phystest(int client, int argc)
{
	// new Float:plypos[3] = {0.0, 0.0, 0.0};
	// new Float:endpos[3] = {0.0, 0.0, 0.0};
	// new Float:plyang[3] = {0.0, 0.0, 0.0};
	// GetClientAbsOrigin(client, plypos);
	// GetClientEyeAngles(client, plyang);	
	// new ent = TracePlayerAngles(client, plyang, 4096.0, endpos);		
		
	// new ient = CreateEntityByName("prop_physics_multiplayer");
	// DispatchKeyValue(ient, "model", "models/dingus/dingus.mdl");
	// DispatchKeyValue(ient, "Solid", "6");
	// DispatchKeyValue(ient, "modelscale", "9");
	// DispatchSpawn(ient);
	// TeleportEntity(ient, endpos, NULL_VECTOR, NULL_VECTOR);
	
	PrintToChat(client, " max ents %i", GetMaxEntities());
	
	new max = GetMaxEntities();
	
	for (new i = 1; i < max; i++)
	{
		if (IsValidEntity(i))
		{
			if (Entity_ClassNameMatches(i, "player", bool:false)
			|| Entity_ClassNameMatches(i, "prop_combine_ball", bool:false)
			|| Entity_ClassNameMatches(i, "prop_physics_multiplayer", bool:false)
			)
			{
				PrintToConsoleAll("%i f %i t %i g %i", i, Entity_GetSolidFlags(i), Entity_GetSolidType(i), Entity_GetCollisionGroup(i));
				if (Entity_ClassNameMatches(i, "prop_combine_ball", bool:false))
				{
					// Entity_SetCollisionGroup(i, 0);
					// Entity_SetSolidType(i, SOLID_VPHYSICS); //SOLID_VPHYSICS == 6
					// ChangeEdictState(i);

					// PrintToConsoleAll("%i f %i t %i g %i --------", i, Entity_GetSolidFlags(i), Entity_GetSolidType(i), Entity_GetCollisionGroup(i));
				}
			}
		}
	}
	
		// 1 f 16 t 2 g 5
		// 2 f 16 t 2 g 5
		// 205 f 0 t 2 g 1 //held
		// 1 f 16 t 2 g 5
		// 2 f 16 t 2 g 5
		// 205 f 0 t 2 g 23 //thrown
		

			// 1 f 16 t 2 g 5
			// 2 f 16 t 2 g 5
			// 3 f 16 t 2 g 5
			// 4 f 16 t 2 g 5
			// 331 f 0 t 6 g 0 //prop_physics_multiplayer
			// 345 f 0 t 2 g 23 //prop_combine_ball
			// 345 set!

	// new ent = jb_getAimTarget(client);
	// PrintToChat(client, "ent? %i", ent);

	return Plugin_Handled;
}


public Action cmdOpenConsole(int client, int args)
{
	// ClientCommand(client, "showconsole");

	return Plugin_Handled;
}


public Action:cmd_jb_CloseMyConsole(int client, int argc)
{
	// ClientCommand(client, "cancelselect");
	return Plugin_Handled;
}


public Action:cmd_myparents(int client, int argc)
{
	new String:sTemp[256];
	// Loop through entities
	for( int i = MaxClients + 1; i < 2048; i++ )
	{
		// Valid and attached to our client
		if( IsValidEdict(i) && HasEntProp(i, Prop_Send, "moveparent") && GetEntPropEnt(i, Prop_Send, "moveparent") == client )
		{
			GetEdictClassname(i, sTemp, sizeof(sTemp));
			PrintToChat(client, "found %i (%s)", i, sTemp);
			// if( strncmp(sTemp, "weapon_", 7) ) // Ignore weapons
			// {
				// Get attachment index
				// att = GetEntProp(i, Prop_Send, "m_iParentAttachment") - 1;

				// From attachment index get attachment string
				// if( att != -1 && att < hListOld.Length && hListOld.GetString(att, sTemp, sizeof(sTemp)) )
				// {
					// Match attachment string and get new index
					// att = hListNew.FindString(sTemp);
					// if( att > -1 )
					// {
						// SetEntProp(i, Prop_Send, "m_iParentAttachment", att + 1);
					// }
				// }
			// }
		}
	}

	return Plugin_Handled;
}


public Action:cmd_jb_playermodels(int client, int argc)
{
	new String:sTemp[256];
	// Loop through entities
	for( int i = 1; i <= MaxClients; i++ )
	{
		// Valid and attached to our client
		if (IsValidEntity(i) && IsEntNetworkable(i))
		{
			Entity_GetModel(i, sTemp, 256);			
			PrintToConsole(client, "found %i (%s)", i, sTemp);
		}
	}

	return Plugin_Handled;
}


public Action:cmd_jb_hudtext(int client, int argc)
{
	for( int i = 1; i <= MaxClients; i++ )
	{
		// Valid and attached to our client
		if (IsClientInGame(i) && IsPlayerAlive(i))
		{
			// PrintHintText(i, "%s", "ass");
			PrintHintText(i, "$<font face=''><font color='#ff00ff'>lmaooo</font></font><br>", "ass");
		}
	}

	return Plugin_Handled;
}


public Action:cmd_buddha(int client, int argc)
{
	if (IsClientInGame(client))
	{
		if (GetEntProp(client, Prop_Data, "m_takedamage") != 1)
		{
			SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);
			g_m_takedamage[client] = 1;
			PrintToChat(client, "\x01Buddha is now \x0700FF00enabled!");
		} else {
			SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
			g_m_takedamage[client] = 2;
			PrintToChat(client, "\x01Buddha is now \x07FF0000disabled!");
		}
	}

	return Plugin_Handled;
}


public Action:cmd_godmode(int client, int argc)
{
	if (IsClientInGame(client))
	{
		if (GetEntProp(client, Prop_Data, "m_takedamage") != 0)
		{
			SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
			g_m_takedamage[client] = 0;
			PrintToChat(client, "\x01Godmode is now \x0700FF00enabled!");
		} else {
			SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
			g_m_takedamage[client] = 2;
			PrintToChat(client, "\x01Godmode is now \x07FF0000disabled!");
		}
	}

	return Plugin_Handled;
}

public Action:cmd_noclip(int client, int argc)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		MoveType movetype = GetEntityMoveType(client);
		
		if (movetype == MOVETYPE_WALK) {
			SetEntityMoveType(client, MOVETYPE_NOCLIP);
			PrintToChat(client, "\x01Noclip \x0700FF00enabled!");
		} else {
			SetEntityMoveType(client, MOVETYPE_WALK);
			PrintToChat(client, "\x01Noclip \x07FF0000disabled!");
		}
	}
	return Plugin_Handled;
}


public Action:cmd_freezeme(int client, int argc)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		// #define FL_ONTRAIN				(1<<4) // Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
		// #define FL_FROZEN				(1<<6) // Player is frozen for 3rd person camera
		// #define FL_ATCONTROLS			(1<<7) // Player can't move, but keeps key inputs for controlling another entity

		
	}
	return Plugin_Handled;
}



public Action cmd_getmycollision(int i, int argc)
{
	PrintToConsoleAll("%i f %i t %i g %i", i, Entity_GetSolidFlags(i), Entity_GetSolidType(i), Entity_GetCollisionGroup(i));
	
	return Plugin_Handled;
}
