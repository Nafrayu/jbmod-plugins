

public Action:cmd_e_stack(int client, int argc)
{
	// new String:args[4000];
	// GetCmdArgString(args, 4000);
	
	new String:amt[256];
	new String:x[256];
	new String:y[256];
	new String:z[256];
	
	new String:px[256];
	new String:py[256];
	new String:pz[256];
	
	GetCmdArg(1, amt, sizeof(amt));
	GetCmdArg(2, x, sizeof(x));
	GetCmdArg(3, y, sizeof(y));
	GetCmdArg(4, z, sizeof(z));
	GetCmdArg(5, px, sizeof(px));
	GetCmdArg(6, py, sizeof(py));
	GetCmdArg(7, pz, sizeof(pz));
	
	int iAmt = StringToInt(amt);
	
	float offset[3];
	offset[0] = StringToFloat(x);
	offset[1] = StringToFloat(y);
	offset[2] = StringToFloat(z);
	
	float pyr[3];
	pyr[0] = StringToFloat(px);
	pyr[1] = StringToFloat(py);
	pyr[2] = StringToFloat(pz);
	
	new Float:endpos[3] = {0.0,0.0,0.0};
	int ent = jb_getAimTargetHit(client, endpos);

	char class[256]
	GetEdictClassname(ent, class, sizeof(class));
	char model[512];
	Entity_GetModel(ent, model, sizeof(model));
	
	if (StrContains(class, "prop_physics", bool:false) != -1)
	{
		float newpos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", newpos);
		float newpyr[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", newpyr);
			
		for (int i = 0; i < iAmt ;i++)
		{
			newpyr[0] = newpyr[0] + pyr[0];
			newpyr[1] = newpyr[1] + pyr[1];
			newpyr[2] = newpyr[2] + pyr[2];

			newpos[0] = newpos[0] + offset[0];
			newpos[1] = newpos[1] + offset[1];
			newpos[2] = newpos[2] + offset[2];
			
			new myfire = CreateEntityByName(class);
			DispatchKeyValue(myfire, "model", model);
			DispatchKeyValue(myfire, "spawnflags", "8");
			DispatchSpawn(myfire);
			
			if (IsValidEntity(myfire) && IsEntNetworkable(myfire))
			{
				TeleportEntity(myfire, newpos, newpyr, NULL_VECTOR ); 
			}
		}
	}
	
	return Plugin_Handled;
}

