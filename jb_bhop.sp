public Plugin:myinfo =
{
	name = "Metastruct Bhop - JBMod Edition",
	author = "Nafrayu",
	description = "Metastruct-style bhop but in JBMod!",
	version = "1.0",
	url = "nafrayu.com"
};


bool g_bhopEnabled[MAXPLAYERS+1];

#include <sourcemod>
#include <sdktools>
#include <entity_prop_stocks>

#pragma semicolon 1


public OnPluginStart()
{
	HookEvent("player_activate", ev_player_activate, EventHookMode_Post);
	
	RegConsoleCmd("bhop", cmd_togglebhop);
	
	//populate initial array
	for (new i=1; i<=MaxClients; i++)
	{
		g_bhopEnabled[i] = bool:true;
	}
}


public OnEventShutdown()
{
	UnhookEvent("player_activate", ev_player_activate);
}


public Action cmd_togglebhop(int client, int args)
{
	g_bhopEnabled[client] = !g_bhopEnabled[client];
	
	if (g_bhopEnabled[client])
	{
		PrintToChat(client, "\x01Bhop is now \x0700FF00enabled!");
	} else {
		PrintToChat(client, "\x01Bhop is now \x07FF0000disabled!");
	}

	return Plugin_Handled;
}


public OnGameFrame()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && g_bhopEnabled[i])
		{
			if (GetEntPropEnt(i, Prop_Data, "m_hGroundEntity") > -1 && (GetClientButtons(i) & IN_JUMP))
			{
				//get current velocity
				decl Float:fVelocity[ 3 ];
				GetEntPropVector(i, Prop_Data, "m_vecVelocity", fVelocity);
				
				float len = GetVectorLength(fVelocity);
				float testlen = len * 1.5;
				
				if (testlen > 3000.0) {
					len = 3000.0 / len;
					ScaleVector(fVelocity, len);
				} else {
					ScaleVector(fVelocity, 1.5);
				}
				
				//set vertical velocity to that of a normal jump
				fVelocity[ 2 ] = 200.0;
				
				//don't stick to the ground
				SetEntPropEnt(i, Prop_Data, "m_hGroundEntity", -1);
				
				//apply changed velocity
				TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, fVelocity);
			}
		}
	}
}


public Action:ev_player_activate(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);

	g_bhopEnabled[client] = bool:true;
}

