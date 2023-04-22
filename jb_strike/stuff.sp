stock int GetRandomPlayerFromTeam(int team)
{
    int clients[256];
    int clientCount;
	
    for (new i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i) && PlayerTeam[i] == team) {
			clients[clientCount] = i;
			clientCount = clientCount + 1;
		}
	}
    return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
}


void Everyone_RespawnFreezeShowScores(bool respawn, int freeze, int showScores)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (freeze == 1)
			{
				PlayerFrozen[i] = true;
				SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 0.0);
			}
			else if (freeze == 0)
			{	
				PlayerFrozen[i] = false;
				SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
			}
			
			if (showScores == 0)
			{
				showVGUIMenu(i, "scores", 0);
			}
			else if (showScores == 1)
			{
				showVGUIMenu(i, "scores", 1);
			}
			
			if (respawn)
			{
				// DispatchSpawn(i);
			}
		}
	}
}

