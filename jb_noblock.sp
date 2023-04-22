public Plugin:myinfo =
{
name = "jbmod noblock",
author = "Nafrayu",
description = "prevents players from getting stuck inside eachother",
version = "1.0",
url = "nafrayu.com"
};


#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>
#include <entity_prop_stocks>
#include <smlib>


#pragma semicolon 1
new Handle:hTimer_PushPlayers;
new Handle:g_Cvars[2] = { INVALID_HANDLE, ... };
#define CVAR_DISTANCE 0
#define CVAR_STRENGTH 0


public OnPluginEnd()
{
	for (new i=1; i<=MaxClients; i++)
	{	
		if (IsValidEntity(i))
		{
			//unhook every player on plugin shutdown
			//this makes it so you can reload the plugin mid-game
			SDKUnhook(i, SDKHook_ShouldCollide, myHookShouldCollide);
		}
	}
	
	KillTimer(hTimer_PushPlayers);
}


public OnPluginStart()
{
	g_Cvars[CVAR_DISTANCE] = CreateConVar("sm_jb_noblock_distance", "8.0", "JBMod noblock distance", _, true, 1.0, true, 64.0);
	g_Cvars[CVAR_STRENGTH] = CreateConVar("sm_jb_noblock_strength", "50.0", "JBMod noblock strength", _, true, 1.0, true, 3500.0);
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsValidEntity(i))
		{
			//hook every player on plugin startup
			//this makes it so you can reload the plugin mid-game
			SDKHook(i, SDKHook_ShouldCollide, myHookShouldCollide);
		}
	}
	
	//only do this 4 times per second to save server resources
	hTimer_PushPlayers = CreateTimer(0.1, fTimer_PushPlayers, _, TIMER_REPEAT);
}


public OnClientPutInServer(client)
{
	//hook every player that joins the server
	//sdkhooks are cleaned up automatically because disconnecting removes the player entity
	SDKHook(client, SDKHook_ShouldCollide, myHookShouldCollide);
}


//the magic of this plugin, wow.
public bool myHookShouldCollide(int entity, int collisiongroup, int contentsmask, bool originalResult)
{
	if (entity > 0 && entity <= MaxClients)
	{
		originalResult = false;
		return false;
	}
	
	return originalResult;
}


//pushes players who are too close together out of the way
public Action:fTimer_PushPlayers(Handle:timer)
{
	//ok this is kinda scuffed:
	//i loop through every player
	//then, for every player, i loop through every other player to check if they are too close
	//if they are too close i push them away.
	
	for (new me=1; me<=MaxClients; me++)
	{
		//make sure they are walking and not driving or noclipping
		if (IsClientInGame(me) && Entity_GetParent(me) == -1 && Entity_GetCollisionGroup(me) != COLLISION_GROUP_IN_VEHICLE && GetEntityMoveType(me) == MOVETYPE_WALK)
		{
			for (new other=1; other<=MaxClients; other++)
			{
				//make sure they are walking and not driving or noclipping
				if (other != me && IsClientInGame(other) && Entity_GetParent(other) == -1 && Entity_GetCollisionGroup(other) != COLLISION_GROUP_IN_VEHICLE && GetEntityMoveType(other) == MOVETYPE_WALK)
				{
					//at this point we are pretty sure both players are alive and walking
					float fMeOrigin[3];
					GetEntPropVector(me, Prop_Data, "m_vecOrigin", fMeOrigin );
					
					float fOtherOrigin[3];
					GetEntPropVector(other, Prop_Data, "m_vecOrigin", fOtherOrigin );
					
					if (GetVectorDistance(fMeOrigin, fOtherOrigin) < GetConVarFloat(g_Cvars[CVAR_DISTANCE]))
					{
						//standing pretty close together, push them!
						
						float fVelocity[3];
						GetEntPropVector(other, Prop_Data, "m_vecVelocity", fVelocity);
						
						//create a vector that points away from the player
						float fAddVelocity[3];
						SubtractVectors(fOtherOrigin, fMeOrigin, fAddVelocity);
						NormalizeVector(fAddVelocity, fAddVelocity);
						
						//multiply this by 190 (walking speed)
						ScaleVector(fAddVelocity, GetConVarFloat(g_Cvars[CVAR_STRENGTH]));
						//add to existing velocity
						AddVectors(fVelocity, fAddVelocity, fAddVelocity);
						
						//now push them
						TeleportEntity(other, NULL_VECTOR, NULL_VECTOR, fAddVelocity);
					}
				}
			}
		}
	}
}

