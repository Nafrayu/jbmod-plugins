

public Action:cmd_e_translate(int client, int argc)
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
	float pos[3];
	GetEntPropVector(ent, Prop_Send, "m_vecOrigin", pos);
	float offset[3];
	offset[0] = StringToFloat(x) + pos[0];
	offset[1] = StringToFloat(y) + pos[1];
	offset[2] = StringToFloat(z) + pos[2];
	//float endpos[3];
	//vec pos;
	if (IsValidEntity(ent) && IsEntNetworkable(ent))
	{
		TeleportEntity(ent, offset, NULL_VECTOR, NULL_VECTOR ); 
	}
	
	return Plugin_Handled;
}

