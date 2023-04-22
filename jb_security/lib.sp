public EntityIsWhitelisted(const String:entname[])
{
	bool whitelisted = bool:false;
	
	bool exists = GetTrieValue(entity_whitelisted, entname, whitelisted);
	
	if (exists && whitelisted)
	{
		return bool:true;
	}
	
	return bool:false;
}


void makeVehicle(client, const String:type[])
{
	new Float:endpos[3] = {0.0,0.0,0.0};
	jb_getAimTargetHit(client, endpos);

	float pos1[3];	
	int entity;
	while ((entity = FindEntityByClassname(entity, "prop_*")) != INVALID_ENT_REFERENCE )
	{
		GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", pos1);
		
		if (GetVectorDistance(endpos, pos1) <= 96)
		{
			PrintToConsole(client, "-----------------------------------");
			PrintToConsole(client, "-- please choose some empty space for your vehicle");
			PrintToConsole(client, "-----------------------------------");
			return;
		}
	}
	
	if (TR_PointOutsideWorld(endpos) == true)
	{
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- cannot create entities in the void");
		PrintToConsole(client, "-----------------------------------");
		return;
	}	
	
	
	char steamid[64];
	GetClientAuthId(client, AuthId_Steam3, steamid, sizeof(steamid));
	
	int amt;
	
	for (new i=1; i <= GetEntityCount(); i++)
	{
		if (IsValidEntity(i) && IsEntNetworkable(i))
		{
			if (pp_canTool(client, i))
			{
				amt = amt + 1; //vehicle limit of 4
				
				if (amt > 2)
				{
					jb_RemoveEntity(i);
				}
			}
		}
	}
	
	int veh;
	
	if (StrContains(type, "jeep") != -1)
	{
		veh = CreateEntityByName("prop_vehicle_jeep");
		DispatchKeyValue(veh, "model", "models/buggy.mdl");
		DispatchKeyValue(veh, "vehiclescript", "scripts/vehicles/jeep_test.txt");
	}
	else if (StrContains(type, "jalopy") != -1)
	{
		veh = CreateEntityByName("prop_vehicle_jeep");
		DispatchKeyValue(veh, "model", "models/vehicle.mdl");
		DispatchKeyValue(veh, "vehiclescript", "scripts/vehicles/jalopy.txt");
	}
	else if (StrContains(type, "pod") != -1)
	{
		veh = CreateEntityByName("prop_vehicle_prisoner_pod");
		DispatchKeyValue(veh, "model", "models/vehicles/prisoner_pod.mdl");
		DispatchKeyValue(veh, "vehiclescript", "scripts/vehicles/prisoner_pod.txt");
	}
	else if (StrContains(type, "airboat") != -1)
	{
		veh = CreateEntityByName("prop_vehicle_airboat");
		DispatchKeyValue(veh, "model", "models/airboat.mdl");
		DispatchKeyValue(veh, "vehiclescript", "scripts/vehicles/airboat.txt");
		
	}
	

	
	// TeleportEntity(veh, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0} );
	
	
	float normal[3];
	TR_GetPlaneNormal(INVALID_HANDLE, normal);	
	
	if( HasEntProp(veh, Prop_Data, "m_vecMins") )
	{
		float vStart[3], vEnd[3];
		float oobcenter[3];

		GetEntPropVector(veh, Prop_Data, "m_vecMins", vStart);
		GetEntPropVector(veh, Prop_Data, "m_vecMaxs", vEnd);
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
	TeleportEntity(veh, endpos, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0} );
	
	DispatchSpawn(veh);
	ActivateEntity(veh);
	pp_setOwner(veh, client);
	
	
}

