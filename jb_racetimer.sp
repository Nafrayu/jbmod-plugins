public Plugin:myinfo =
{
name = "jbmod racetimer",
author = "Nafrayu",
description = "no description",
version = "1.0",
url = "nafrayu.com"
};


//static stuff
new Handle:hTimer_DrawZones;
new LaserCache = 0;
new HaloSprite = 0;
int g_entity_index = 1;

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

#include "jb_includes/3x4_matrix.sp"
#include "jb_includes/4x4_matrix.sp"
#include "jb_includes/toScreen.sp"
#include "jb_includes/jb_lib.sp"
#include "jb_includes/SendKeyHintText.inc"
#include "jb_includes/SendMsg_HudMsg.inc"
#include "jb_includes/drawing.sp"


#pragma semicolon 1
// chat must begin with \x01 to activate color codes
// \x07 followed by a hex code in RRGGBB format
// \x08 followed by a hex code with alpha in RRGGBBAA format


public OnMapStart()
{

}

public Action:trigger_touchstart(int entity, int other)
{
	// new String:cls[128];
	// GetEntityClassname(entity, cls, sizeof(cls));	
	// new String:target_name[128];
	// GetEntPropString(entity, Prop_Data, "m_iName", target_name, sizeof(target_name));	
	// PrintToServer("     index %i other %i clsname %s targetname '%s'", entity, other, cls, target_name);
	
	if (other > 0 && other < MaxClients + 1)
	{
		// PrintToChat(other, "\x01\x0700FF00entering checkpoint (on foot)");
	}
	
	for (new i=1; i<=MaxClients; i++)
	{	
		if (IsValidEntity(i))
		{
			int specta = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
			
			if (specta == other && other > MaxClients+1)
			{
				// PrintToChat(i, "\x01\x0700FF00entering checkpoint (melonrace mode)");
			}
		}
	}
}

public Action:trigger_touchend(int entity, int other)
{
	// new String:cls[128];
	// GetEntityClassname(entity, cls, sizeof(cls));	
	// new String:target_name[128];
	// GetEntPropString(entity, Prop_Data, "m_iName", target_name, sizeof(target_name));	
	// PrintToServer("     index %i other %i", entity, other, cls, target_name);
	
	if (other > 0 && other < MaxClients + 1)
	{
		// PrintToChat(other, "\x01\x07FF0000leaving checkpoint (on foot)");
	}
	
	for (new i=1; i<=MaxClients; i++)
	{	
		if (IsValidEntity(i))
		{
			int specta = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
			
			if (specta == other && other > MaxClients+1)
			{
				// PrintToChat(i, "\x01\x07FF0000leaving checkpoint (melonrace mode)");
			}
		}
	}
}


public OnEventShutdown()
{

}


public OnPluginEnd()
{
	decl String:cmap[256];
	GetCurrentMap(cmap, 256);	
	if (StrContains(cmap, "jb_freewireconstructblocks_v3") != -1)
	{
		KillTimer(hTimer_DrawZones);
		
		int entity_index = MaxClients+1; // Skip all client indexs...
		
		while((entity_index = FindEntityByClassname(entity_index, "trigger_multiple")) != -1)
		{
			SDKUnhook(entity_index, SDKHook_StartTouch, trigger_touchstart);
			SDKUnhook(entity_index, SDKHook_EndTouch, trigger_touchend);
		}
	}
}


public OnPluginStart()
{
	decl String:cmap[256];
	GetCurrentMap(cmap, 256);	
	if (StrContains(cmap, "jb_freewireconstructblocks_v3") != -1)
	{
		g_entity_index = MaxClients + 1;
		
		hTimer_DrawZones = CreateTimer(0.25, fTimer_DrawZones, _, TIMER_REPEAT);
		LaserCache = PrecacheModel("sprites/laserbeam.spr");
		HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
		
		int entity_index = MaxClients + 1; // Skip all client indexs...
		while((entity_index = FindEntityByClassname(entity_index, "trigger_multiple")) != -1)
		{
			// Entity_SetSpawnFlags(entity_index, 512); // ONLY CLIENTS NOT IN VEHICLES
			SDKHook(entity_index, SDKHook_StartTouch, trigger_touchstart);
			SDKHook(entity_index, SDKHook_EndTouch, trigger_touchend);
			
			// new String:cls[128];
			// GetEntityClassname(entity_index, cls, sizeof(cls));
			// new String:target_name[128];
			// GetEntPropString(entity_index, Prop_Data, "m_iName", target_name, sizeof(target_name));
			// PrintToServer("     HOOKED index %i clsname %s targetname '%s'", entity_index, cls, target_name);
		}
	}
}


// public OnClientPutInServer(client)
// {
	// SDKHook(client, SDKHook_OnTakeDamage, Godmode_OnTakeDamage);
	// SDKHook(client, SDKHook_OnTakeDamage, FixFalldamage_OnTakeDamage);
// }


public Action:fTimer_DrawZones(Handle:timer)
{
	
	int entity_index = MaxClients + 1; // Skip all client indexs...
	while((entity_index = FindEntityByClassname(entity_index, "trigger_multiple")) != -1)
	{
		float zone[8][3], origin[3];
		GetEntPropVector(entity_index, Prop_Data, "m_vecOrigin", origin);
		GetEntPropVector(entity_index, Prop_Data, "m_vecMins", zone[0]);
		GetEntPropVector(entity_index, Prop_Data, "m_vecMaxs", zone[7]);
		AddVectors(origin, zone[0], zone[0]);
		AddVectors(origin, zone[7], zone[7]);

		CreateZonePoints(zone);
		DrawZone(0, zone, LaserCache, HaloSprite, {255, 0, 0, 255}, 10.0);
	}

}











