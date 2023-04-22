// public pp_getOwner(ent)
// {

// }
void pp_setOwner(ent, client)
{
	char steamid[256];
	GetClientAuthId(client, AuthId_Steam3, steamid, sizeof(steamid));
	
	SetArrayString(g_propowner, ent, steamid);
}


bool pp_canTool(client, ent)
{
	char steamid[64];
	GetClientAuthId(client, AuthId_Steam3, steamid, sizeof(steamid));

	char owner[64];
	int hasowner = GetArrayString(g_propowner, ent, owner, 64);
	
	return ((hasowner > 0 && StrEqual(owner, steamid)) == true)
}



public Action:ev_disconnect_propprotection_disconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	char steamid[50];
	GetEventString(event, "networkid", steamid, sizeof(steamid));
	
	for (new i=1; i<=GetEntityCount(); i++)
	{
		if (IsValidEntity(i) && IsEntNetworkable(i))
		{
			char owner[64];
			int hasowner = GetArrayString(g_propowner, i, owner, 64);
			
			if (hasowner > 0 && StrEqual(owner, steamid) == true)
			{
				jb_RemoveEntity(i);
			}
			
			// decl String:class1[256];
			// GetEntityClassname(i, class1, 256);
			
			// if (StrEqual(class1, "gravity_pellet", false))
			// {
				// new weapon = GetEntPropEnt(i, Prop_Send, "m_hOwnerEntity");
				
				// if (IsValidEntity(weapon) && IsEntNetworkable(weapon))
				// {
					// new owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
					
					// if (owner == iClient || owner == -1) {
						// jb_RemoveEntity(i);
					// }
				// }
			// }
		}
	}
	
	return Plugin_Continue;
}

