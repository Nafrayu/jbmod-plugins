public Action:trigger_touchstart(int entity, int other)
{
	if (other > 0 && other < MaxClients + 1)
	{
		char targetname[256];
		Entity_GetName(entity, targetname, 256);
		
		// PrintToChat(other, "entering bomb site");
		
		if (StrEqual(targetname, "bombsite"))
		{
			PrintToChat(other, "entering bomb site");
		}	
	}
}


public Action:trigger_touchend(int entity, int other)
{
	if (other > 0 && other < MaxClients + 1)
	{
		char targetname[256];
		Entity_GetName(entity, targetname, 256);
		
		// PrintToChat(other, "leaving bomb site");
		
		if (StrEqual(targetname, "bombsite"))
		{
			PrintToChat(other, "leaving bomb site");
		}	
	}
}

