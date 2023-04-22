public Plugin:myinfo =
{
	name = "FOV Changer",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


int g_fov[MAXPLAYERS+1];
int LaserCache = 0;
int HaloSprite = 0;

#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>
#include <smlib>
#include <entity_prop_stocks>
#include <entity_prop_stocks>
#include "jb_includes/jb_lib.sp"

#pragma semicolon 1


public OnPluginStart()
{
	RegConsoleCmd("sm_fov", cmd_fov);
	RegConsoleCmd("sm_flipvm", cmd_flipvm);
}


public Action:cmd_fov(client, args)
{
	decl String:sarg1[65];
	GetCmdArg(1, sarg1, sizeof(sarg1));
	new newFov = StringToInt(sarg1);
	
	if (newFov > 0 && newFov < 360)
	{
		g_fov[client] = newFov;
		PrintToChat(client, "Changed FOV to %i", newFov);
	}
	else
	{
		PrintToChat(client, "FOV out of range! (1 to 359) Your FOV has been reset.");
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		SetEntProp(client, Prop_Send, "m_iDefaultFOV", 90);
		g_fov[client] = 0;
	}

	return Plugin_Handled;
}


public OnGameFrame()
{
	for (new i = 1; i <= MaxClients; i++) {
		if (IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i)) {
			if (g_fov[i] != 0
				&& (GetEntProp(i, Prop_Send, "m_iFOV") != g_fov[i]
				|| GetEntProp(i, Prop_Send, "m_iDefaultFOV") != g_fov[i])
			)
			{
				SetEntProp(i, Prop_Send, "m_iFOV", g_fov[i]);
				SetEntProp(i, Prop_Send, "m_iDefaultFOV", g_fov[i]);
			}
		}
	}
}


public OnClientPutInServer(client)
{
	g_fov[client] = 0;
}


public OnClientDisconnect(client)
{
	g_fov[client] = 0;
}



public Action:cmd_flipvm(client, args)
{
	// decl String:sarg1[65];
	// GetCmdArg(1, sarg1, sizeof(sarg1));
	// new newFov = StringToInt(sarg1);
	
	PrintToChat(client, "Flipping view model");
	
	// int viewmodel = GetViewModel(client);
	int weapon = Client_GetActiveWeapon(client);
	
	PrintToChat(client, "weapon entity: %i", weapon);
	
	SetEntProp(weapon, Prop_Send, "m_bFlipViewModel", 1);
	
	PrintToChat(client, "View model flipped");

	return Plugin_Handled;
}












