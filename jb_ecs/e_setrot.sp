

public Action:cmd_e_setrot(int client, int argc)
{
	// new String:args[4000];
	// GetCmdArgString(args, 4000);
	
	new String:x[256];
	GetCmdArg(1, x, sizeof(x));

	new String:y[256];
	GetCmdArg(2, y, sizeof(y));
	
	new String:z[256];
	GetCmdArg(3, z, sizeof(z));
	
	new Float:endpos[3] = {0.0,0.0,0.0};
	int ent = jb_getAimTargetHit(client, endpos);
	
	float pyr[3];
	pyr[0] = StringToFloat(x);
	pyr[1] = StringToFloat(y);
	pyr[2] = StringToFloat(z);
	
	if (IsValidEntity(ent) && IsEntNetworkable(ent))
	{
		TeleportEntity(ent, NULL_VECTOR, pyr, NULL_VECTOR ); 
	}
	
	return Plugin_Handled;
}

