public Plugin:myinfo =
{
	name = "jbmod melonracer test",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


// new Handle:drawscoresTimer;
// new Handle:rebuildScoresTimer;


int g_melonrace[256];
int LaserCache = 0;

// FORWARD_SPEED 	= 170;
// REVERSE_SPEED 	= -40;

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
	UnhookEvent("player_spawn", ev_spawn);
	UnhookEvent("player_activate", ev_activate);
	UnhookEvent("player_disconnect", ev_disconnect);
	UnhookEvent("player_connect", ev_connect);
}


public OnPluginEnd()
{
	// KillTimer(drawscoresTimer);
}


public OnPluginStart()
{
	AddCommandListener(spec_getout, "spec_next");
	AddCommandListener(spec_getout, "spec_prev");
	AddCommandListener(spec_getout, "spec_mode");
	AddCommandListener(spec_getout, "spectate");
	AddCommandListener(spec_getout, "spec_player");
		
	HookEvent("player_spawn", ev_spawn, EventHookMode_Post);
	HookEvent("player_activate", ev_activate, EventHookMode_Post);	
	HookEvent("player_disconnect", ev_disconnect, EventHookMode_Pre);
	HookEvent("player_connect", ev_connect, EventHookMode_Pre);

	// hTimer_drawAdverts = CreateTimer(1.0, fTimer_drawAdverts, _, TIMER_REPEAT);
	
	RegConsoleCmd("melonrace", cmd_melonrace);
	
	for (new i=1; i<=MaxClients; i++)
	{
		g_melonrace[i] = INVALID_ENT_REFERENCE;
	}
}


// 81 - cooldown - cubemap
// 82 - redirect - jeep
// 83 - redirect - airboat
// 100 - allow always - flashlight
// 200 - cooldown - holster
// 201 - allow always - spraylogo
// 203 - redirect - remove

public Action:OnPlayerRunCmd(
	client, &buttons, &impulse, Float:vel[3], Float:angles[3],
	&weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{	
	new melon = EntRefToEntIndex(g_melonrace[client]);
	
	if (melon != INVALID_ENT_REFERENCE && IsValidEntity(melon) && HasPhysics(melon))
	{
		if (buttons & IN_RELOAD)
		{
			g_melonrace[client] = INVALID_ENT_REFERENCE;
			FakeClientCommand(client, "jointeam 2");
			
			buttons = buttons & ~IN_RELOAD; 
			return Plugin_Changed;
		}
		if (buttons & IN_ATTACK)
		{
			buttons = buttons & ~IN_ATTACK; 
			return Plugin_Changed;
		}
		if (buttons & IN_ATTACK2)
		{
			buttons = buttons & ~IN_ATTACK2;
			return Plugin_Changed;
		}
		if (buttons & IN_JUMP)
		{
			buttons = buttons & ~IN_JUMP;
			return Plugin_Changed;
		}
		if (buttons & IN_DUCK)
		{
			buttons = buttons & ~IN_DUCK; 
			return Plugin_Changed;
		}
	}
	else if (melon != INVALID_ENT_REFERENCE)
	{
		g_melonrace[client] = INVALID_ENT_REFERENCE;
	}
	
	
	return Plugin_Continue;
}


// public OnEntityCreated(entity, const String:classname[])
// {
// }


public Action:ev_spawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	g_melonrace[client] = INVALID_ENT_REFERENCE;
	
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
}


public Action:ev_activate(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	g_melonrace[client] = INVALID_ENT_REFERENCE;
}


public OnGameFrame()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			new melon = EntRefToEntIndex(g_melonrace[i]);
			
			if (melon != INVALID_ENT_REFERENCE && IsValidEntity(melon) && HasPhysics(melon))
			{
				new buttons = GetClientButtons(i);
				
				if (buttons & IN_FORWARD)
				{					
					new Float:plyang[3];
					GetClientEyeAngles(i, plyang);
					
					decl Float:fwd[ 3 ];
					GetAngleVectors(plyang,fwd,NULL_VECTOR,NULL_VECTOR);
					ScaleVector(fwd, Phys_GetMass(melon) * 17.0);
					fwd[2] = 0.0;
					
					// native void Phys_ApplyForceCenter(int iEntity, const float forceVector[3]);
					Phys_ApplyForceCenter(melon, fwd);
					SetEntProp(i, Prop_Send, "m_iObserverMode", SPECMODE_3RDPERSON);
					SetEntPropEnt(i, Prop_Send, "m_hObserverTarget", melon);
				}
			}
		}
	}
}


public Action:ev_disconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	g_melonrace[client] = INVALID_ENT_REFERENCE;

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


public Action:cmd_melonrace(client, args)
{
	new ent = jb_getAimTarget(client);
	
	PrintToConsole(client, "now spectating %i", ent);
	
	if (IsValidEntity(ent) && HasPhysics(ent))
	{
		
		// m_iObserverMode
		// m_hObserverTarget
		
		
		SetEntProp(client, Prop_Send, "m_iObserverMode", SPECMODE_3RDPERSON);
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", ent);
		Entity_AddFlags(client, 1<<7);
		g_melonrace[client] = EntIndexToEntRef(ent);
		
		// int SpecMode = GetEntProp(client, Prop_Send, "m_iObserverMode");
		
		// if (SpecMode != SPECMODE_FIRSTPERSON || SPECMODE_3RDPERSON)
			// return Plugin_Handled;
			
		// int Target = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
			
			// g_melonrace[client] = ent;
		// }
	}
	return Plugin_Handled;
}


public Action:spec_getout(client, const String:command[], argc) {
	FakeClientCommand(client, "jointeam 2");
	Entity_RemoveFlags(client, 1<<7);
	g_melonrace[client] = INVALID_ENT_REFERENCE;
	PrintToConsole(client, "        melonracer exit");
	return Plugin_Stop;
}


