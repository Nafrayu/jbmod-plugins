
public Action:cmd_jb_thrustOn(int client, int argc)
{
	char args[3];
	GetCmdArgString(args, 3);
	int whichThruster = StringToInt(args);
	
	int i = MaxClients + 1; // Skip all client indexs...
	
	while((i = FindEntityByClassname(i, "physics_cannister")) != -1)
	{
		if (IsThrusterOwner(i, client) && g_iThrusterNumber[i] == whichThruster)
		{
			SetEntPropFloat(i, Prop_Data, "m_thrustTime", 2000000000.0);
			AcceptEntityInput(i, "Activate");
		}
	}
	
	PrintToConsole(client, "\t[JBMOD] thruster %i ON", whichThruster);
	
	return Plugin_Handled;
}


public Action:cmd_jb_thrustOff(int client, int argc)
{
	char args[3];
	GetCmdArgString(args, 3);
	int whichThruster = StringToInt(args);
	
	int i = MaxClients + 1; // Skip all client indexs...
	
	while((i = FindEntityByClassname(i, "physics_cannister")) != -1)
	{
		if (IsThrusterOwner(i, client) && g_iThrusterNumber[i] == whichThruster)
		{
			AcceptEntityInput(i, "Deactivate");
		}
	}
	
	PrintToConsole(client, "\t[JBMOD] thruster %i OFF", whichThruster);
	
	return Plugin_Handled;
}


public Action:cmd_jb_thrust_num(int client, int argc)
{
	new String:args[3];
	GetCmdArgString(args, 3);

	g_iThrusterNumberSetting[client] = StringToInt(args);
	
	PrintToConsole(client, "\t[JBMOD] thrust numpad set to %i", g_iThrusterNumberSetting[client]);
	
	return Plugin_Handled;
}
















