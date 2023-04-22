public Plugin:myinfo =
{
	name = "jbmod sprite",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


int LaserCache = 0;


#define SPECMODE_NONE    0
#define SPECMODE_FIRSTPERSON    4
#define SPECMODE_3RDPERSON    5
#define SPECMODE_FREELOOK    6

#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>
#include <entity_prop_stocks>
#include <dhooks>
#include <smlib>
#include <vphysics>

#include "jb_includes/jb_lib.sp"
#include "jb_includes/SendKeyHintText.inc"
#include "jb_includes/SendMsg_HudMsg.inc"


#pragma semicolon 1


public OnMapStart()
{
	// LaserCache = PrecacheModel("sprites/laserbeam.spr");
	// HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
}


public OnEventShutdown()
{
}


public OnPluginEnd()
{
	// KillTimer(drawscoresTimer);
}


public OnPluginStart()
{
		
	HookEvent("player_spawn", ev_spawn, EventHookMode_Post);
	HookEvent("player_activate", ev_activate, EventHookMode_Post);	
	HookEvent("player_disconnect", ev_disconnect, EventHookMode_Pre);
	HookEvent("player_connect", ev_connect, EventHookMode_Pre);

	// hTimer_drawAdverts = CreateTimer(1.0, fTimer_drawAdverts, _, TIMER_REPEAT);
	
	RegConsoleCmd("spritemodel", cmd_spritemodel);
	
	// for (new i=1; i<=MaxClients; i++)
	// {
		
	// }
}

// public OnEntityCreated(entity, const String:classname[])
// {
// }


public Action:ev_spawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	// for (new i=1; i<=MaxClients; i++)
	// {
		// if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		// {
			// new melon = EntRefToEntIndex(g_melonrace[i]);
			
			// if (melon != INVALID_ENT_REFERENCE && IsValidEntity(melon) && HasPhysics(melon))
			// {
				// SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", melon);
			// }
		// }
	// }
	
	return Plugin_Continue;
}


public Action:ev_activate(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	return Plugin_Continue;
}


public Action:ev_disconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	// g_melonrace[client] = INVALID_ENT_REFERENCE;

	return Plugin_Continue;
}


public Action:ev_connect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iIndex = GetEventInt(event, "index");
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	// g_melonrace[client] = INVALID_ENT_REFERENCE;

	return Plugin_Continue;
}


public Action:cmd_spritemodel(client, args)
{
	// new ent = jb_getAimTarget(client);
	
	// PrintToConsole(client, "now spectating %i", ent);
	
	// ent_create env_sprite model "matsys_regressiontest/background.vmt" scale 15 frame 1 rendermode 0 rendercolor "255 255 255"
	
	new ient = CreateEntityByName("env_sprite");
	// DispatchKeyValue(iEntity, "targetname", sBuffer);
	DispatchKeyValue(ient, "model", "matsys_regressiontest/background.vmt");
	DispatchKeyValue(ient, "scale", "1");
	// DispatchKeyValue(ient, "frame", "1");
	// DispatchKeyValue(ient, "rendermode", "1");
	DispatchSpawn(ient);
	
	Entity_SetParent(ient, client);
	
	TeleportEntity(ient, {0.0,0.0,0.0}, NULL_VECTOR, NULL_VECTOR);
		
	PrintToConsole(client, "Your sprite model has been set to materials/editor/env_explosion.vtf");

	return Plugin_Handled;
}













