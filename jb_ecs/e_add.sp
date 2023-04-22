

public Action:cmd_e_add(int client, int argc)
{
	new String:args[4000];
	GetCmdArgString(args, 4000);
	
	new String:class[256];
	GetCmdArg(1, class, sizeof(class));
	
	new Float:endpos[3] = {0.0,0.0,0.0};
	jb_getAimTargetHit(client, endpos);
	
	new myfire = CreateEntityByName(class);

	if (argc % 2 > 0)
	{
		for (new i = 2; i <= argc; i=i+2)
		{
			
			new String:key[256];
			GetCmdArg(i, key, sizeof(key));
			
			if (i+1 <= argc)
			{
				new String:val[256];
				GetCmdArg(i+1, val, sizeof(val));
				
				DispatchKeyValue(myfire, key, val);
			}
		}
	}
	
	TeleportEntity(myfire, endpos, NULL_VECTOR, NULL_VECTOR ); 
	
	DispatchSpawn(myfire);

	return Plugin_Handled;
}

