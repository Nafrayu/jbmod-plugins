// chat must begin with \x01 to activate color codes
// \x07 followed by a hex code in RRGGBB format
// \x08 followed by a hex code with alpha in RRGGBBAA format

public Plugin:myinfo =
{
name = "jbmod misc",
author = "Nafrayu",
description = "no description",
version = "1.0",
url = "nafrayu.com"
};


//static stuff
new ConVar:g_cvarFallDamageToggle;
int advertTime = 0;
int curAdvert = 0;
int curAdvertChat = 0;
new Handle:hTimer_keepFreeSlot;
new Handle:hTimer_drawAdverts;
new Handle:hTimer_chatAdverts;
new Handle:hTimer_playerParentCheck;
// new Handle:drawscoresTimer;
// new Handle:rebuildScoresTimer;
new LaserCache = 0;
// new HaloSprite = 0;


//temp gameplay stuff
int curChannel[MAXPLAYERS+1];
// int showScores[MAXPLAYERS+1];
// int curPly[MAXPLAYERS+1];
int g_lastchat[MAXPLAYERS+1];
int g_m_takedamage[MAXPLAYERS+1];
new String:lastmessage[MAXPLAYERS+1][256];
// new String:scoresContent[MAXPLAYERS+1][256];


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
#include "jb_misc/cmd.sp"
#include "jb_misc/chat.sp"
#include "jb_misc/scores.sp"
#include "jb_misc/takedmg.sp"


#pragma semicolon 1


public OnMapStart()
{
	LaserCache = PrecacheModel("sprites/laserbeam.spr");
	// HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
}


public OnEventShutdown()
{
	UnhookEvent("player_spawn", ev_player_spawn_giveitems);
	UnhookEvent("player_activate", ev_player_activate_fixstuff);
	UnhookEvent("player_disconnect", ev_PlayerDisconnect);
	UnhookEvent("player_connect", ev_PlayerConnect);
}


public OnPluginEnd()
{
	// KillTimer(drawscoresTimer);
	// KillTimer(rebuildScoresTimer);
	KillTimer(hTimer_drawAdverts);
	KillTimer(hTimer_chatAdverts);
	KillTimer(hTimer_playerParentCheck);
	KillTimer(hTimer_keepFreeSlot);
	
	for (new i=1; i<=MaxClients; i++)
	{	
		if (IsValidEntity(i))
		{
			SDKUnhook(i, SDKHook_OnTakeDamage, Godmode_OnTakeDamage);
			SDKUnhook(i, SDKHook_OnTakeDamage, FixFalldamage_OnTakeDamage);
		}
	}
}

// 13307 1746 -13260
// 11327 -2273 -13260

public OnPluginStart()
{
	// scoresContent = CreateArray(256);
	
	// HookEvent("player_spawn", ev_player_spawn_giveitems_pre, EventHookMode_Pre);
	HookEvent("player_spawn", ev_player_spawn_giveitems, EventHookMode_Post);
	HookEvent("player_activate", ev_player_activate_fixstuff, EventHookMode_Post);

	HookEvent("player_disconnect", ev_PlayerDisconnect, EventHookMode_Pre);
	HookEvent("player_connect", ev_PlayerConnect, EventHookMode_Pre);

	AddCommandListener(OnSayCmd, "say");
	AddCommandListener(OnSayCmd, "say_team");

	// drawscoresTimer = CreateTimer(0.25, drawScoresFunc, _, TIMER_REPEAT);
	// rebuildScoresTimer = CreateTimer(1.0, rebuildScores, _, TIMER_REPEAT);
	hTimer_keepFreeSlot = CreateTimer(1.0, fTimer_keepFreeSlot, _, TIMER_REPEAT);
	hTimer_drawAdverts = CreateTimer(1.0, fTimer_drawAdverts, _, TIMER_REPEAT);
	hTimer_chatAdverts = CreateTimer(120.0, fTimer_chatAdverts, _, TIMER_REPEAT);	
	hTimer_playerParentCheck = CreateTimer(0.25, fTimer_playerParentCheck, _, TIMER_REPEAT);
	// 1 f 16 t 2 g 5
	// 1 f 16 t 2 g 10

	RegAdminCmd("getmycollision", cmd_getmycollision, ADMFLAG_GENERIC, "show collision mode");
	RegConsoleCmd("console", cmdOpenConsole);
	RegConsoleCmd("phystest", cmd_phystest);
	RegConsoleCmd("jb_CloseMyConsole", cmd_jb_CloseMyConsole);
	RegConsoleCmd("jb_playermodels", cmd_jb_playermodels);
	RegConsoleCmd("myparents", cmd_myparents);
	RegConsoleCmd("freezeme", cmd_freezeme);
	RegConsoleCmd("sm_buddha", cmd_buddha);
	RegConsoleCmd("sm_godmode", cmd_godmode);
	RegConsoleCmd("sm_god", cmd_godmode);
	RegConsoleCmd("sm_noclip", cmd_noclip);
	
	RegAdminCmd("sm_motd_stream", command_motdstream, ADMFLAG_RCON);
	
	g_cvarFallDamageToggle = FindConVar("mp_falldamage");
	
	RegAdminCmd("hudtext", cmd_jb_hudtext, ADMFLAG_GENERIC, "");
	
	for (new i=1; i<=MaxClients; i++)
	{
		g_lastchat[i] = 0;
		curChannel[i] = 0;
		g_m_takedamage[i] = 2;
		
		if (IsValidEntity(i))
		{
			int takedmg = GetEntProp(i, Prop_Data, "m_takedamage");
			g_m_takedamage[i] = takedmg;
			SDKHook(i, SDKHook_OnTakeDamage, Godmode_OnTakeDamage);
			SDKHook(i, SDKHook_OnTakeDamage, FixFalldamage_OnTakeDamage);
		}
	}
}


public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, Godmode_OnTakeDamage);
	SDKHook(client, SDKHook_OnTakeDamage, FixFalldamage_OnTakeDamage);
}


public Action:OnPlayerRunCmd(
	client, &buttons, &impulse, Float:vel[3], Float:angles[3],
	&weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	if (Entity_GetParent(client) > 0)
	{
		if (buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT)
		{
			vel[0] = 0.0;
			vel[1] = 0.0;
			vel[2] = 0.0;
			// if (buttons & IN_FORWARD) {buttons = buttons & ~IN_FORWARD;}
			// if (buttons & IN_BACK) {buttons = buttons & ~IN_BACK;}
			// if (buttons & IN_MOVELEFT) {buttons = buttons & ~IN_MOVELEFT;}
			// if (buttons & IN_MOVERIGHT) {buttons = buttons & ~IN_MOVERIGHT;}
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}


// public void RequestFrame_NewEnt(int tempent)
public Action:RequestFrame_NewEnt(Handle:Timer, tempent)
{
	int ent = EntRefToEntIndex(tempent);
	if (ent == INVALID_ENT_REFERENCE) {return;}
	if (!IsValidEntity(ent)) {return;}

	float vPos[3];
	float vEnt[3];
	GetEntPropVector(ent, Prop_Data, "m_vecAbsOrigin", vPos);
	
	// PrintToServer("%f %f %f", vPos[0], vPos[1], vPos[2]);
	
	int props = 0;
	
	for( int i = 1; i < 2047; i++ )
	{
		if( IsValidEntity(i) && IsValidEdict(i) )
		{
			if (   (i > 0 )
			&& (
			Entity_ClassNameMatches(i, "prop_physics", bool:true)
			// || Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
			|| Entity_ClassNameMatches(i, "func_physbox", bool:true)
			// || Entity_ClassNameMatches(ent, "prop_ragdoll", bool:true)
			)
			)
			{
				GetEntPropVector(i, Prop_Data, "m_vecAbsOrigin", vEnt);
				
				if(GetVectorDistance(vPos, vEnt) <= 96 )
				{
					props++;
					
					if (props > 7)
					{
						// GetEdictClassname(i, sTemp, sizeof(sTemp));
						// ReplyToCommand(client, "%d. %f - %s", i, GetVectorDistance(vPos, vEnt), sTemp);
						jb_RemoveEntity(i);
					// } else
					// {
						// PrintToServer("disablemotion %i", i);
						// AcceptEntityInput(i, "disablemotion");
					}
				}
			}
		}
	}
	
}


public OnGameFrame()
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			int parent = Entity_GetParent(i);
			
			if (parent > 0 && Entity_GetCollisionGroup(i) != COLLISION_GROUP_IN_VEHICLE)
			{
				int root = Entity_GetParentRoot(i);
				
				// GetEntPropVector(i, Prop_Data, "m_vecVelocity", Float:{0.0,0.0,0.0});
				
				int buttons = GetClientButtons(i);

				if (buttons & IN_FORWARD || buttons & IN_BACK || buttons & IN_MOVELEFT || buttons & IN_MOVERIGHT)
				{
					float plypos[3]; GetEntPropVector(i, Prop_Data, "m_vecOrigin", plypos);
					float plyang[3]; GetClientEyeAngles(i, plyang);
					
					// PrintToConsole(i, "plyang: %f %f %f", plyang[0], plyang[1], plyang[2]);
					
					float propPos[3]; 
					float propAng[3];
					
					if (root == parent)
					{
						GetEntPropVector(parent, Prop_Send, "m_vecOrigin", propPos);
						GetEntPropVector(parent, Prop_Send, "m_angRotation", propAng);
					}
					else
					{
						float rootPos[3];
						float rootAng[3];
						
						GetEntPropVector(root, Prop_Send, "m_vecOrigin", rootPos);
						GetEntPropVector(root, Prop_Send, "m_angRotation", rootAng);
						
						GetEntPropVector(parent, Prop_Send, "m_vecOrigin", propPos);
						GetEntPropVector(parent, Prop_Send, "m_angRotation", propAng);
						
						LTOW(propPos, propAng, rootPos, rootAng, propPos, propAng);
					}
					
					
					
					// PrintToConsole(i, "propAng: %f %f %f", propAng[0], propAng[1], propAng[2]);
					
					float worldpos[3];
					LTOW(plypos, NULL_VECTOR, propPos, propAng, worldpos, NULL_VECTOR);
					
					
					float endpos[3];
					float finalpos[3];
					
					float fw[3]; float rg[3]; float up[3]; GetAngleVectors(plyang, fw, rg, up);
					
					new ent = jb_getAimTargetHit(i, endpos);
					
					LTOW(plypos, NULL_VECTOR, propPos, propAng, worldpos, NULL_VECTOR);
					
					if (buttons & IN_FORWARD) {
						ScaleVector(fw, 4.84 );
						AddVectors(worldpos, fw, worldpos);
					} else if (buttons & IN_BACK) {
						ScaleVector(fw, -4.84 );
						AddVectors(worldpos, fw, worldpos);
					}
					if (buttons & IN_MOVELEFT) {
						ScaleVector(rg, -4.84 );
						AddVectors(worldpos, rg, worldpos);
					} else if (buttons & IN_MOVERIGHT) {
						ScaleVector(rg, 4.84 );
						AddVectors(worldpos, rg, worldpos);
					}
					
					WTOL(worldpos, NULL_VECTOR, propPos, propAng, finalpos, NULL_VECTOR);
					
					SetEntPropVector(i, Prop_Data, "m_vecOrigin", finalpos);
					
					// TE_SetupBeamPoints(worldpos, endpos, LaserCache, 0, 0, 0, 0.1, 4.0, 4.0, 1, 0.0, {255,255,255,255}, 0);
					// TE_SendToAll(0.0);
				}
			}
		}
	}
}


public OnEntityCreated(ent, const String:classname[])
{
	// g_createdEntRef = EntIndexToEntRef(ent);
	// RequestFrame(RequestFrame_NewEnt, EntIndexToEntRef(ent));
	if (IsValidEntity(ent) && IsEntNetworkable(ent))
	{
		CreateTimer(0.03, RequestFrame_NewEnt, ent, TIMER_FLAG_NO_MAPCHANGE);
	}
}


public Action:ev_player_spawn_giveitems(Handle:event, const String:name[], bool:dontBroadcast)
{
	decl String:cmap[256];
	GetCurrentMap(cmap, 256);	
	
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	SetEntProp(client, Prop_Data, "m_takedamage", g_m_takedamage[client], 1);
	
	//throw the player away from spawn to prevent tele fragging

	decl Float:fVecOrigin[ 3 ];
	decl Float:fVelocity[ 3 ];

	GetEntPropVector( client, Prop_Data, "m_vecOrigin", fVecOrigin );
	GetEntPropVector( client, Prop_Data, "m_vecVelocity", fVelocity );

	// fVecOrigin[ 0 ] = fVecOrigin[ 0 ] + GetRandomFloat(-64.0, 64.0);
	// fVecOrigin[ 1 ] = fVecOrigin[ 1 ] + GetRandomFloat(-64.0, 64.0);
	if (StrContains(cmap, "jb_freewireconstructblocks_v3") != -1)
	{
		// setpos 11408.062500 -1033.718750 -13243.156250;setang 33.791996 47.379379 0.000000
		// setpos 13497.187500 2113.000000 -13239.437500;setang 60.059990 -128.312790 0.000000


		fVecOrigin[ 0 ] = GetRandomFloat(11408.0, 13497.0);
		fVecOrigin[ 1 ] = GetRandomFloat(-1033.0, 2113.0);
		fVecOrigin[ 2 ] = -13259.0;
		// fVecOrigin[ 2 ] = fVecOrigin[ 2 ] + 32.0;
		
		fVelocity[ 0 ] = -1000.0;
		fVelocity[ 1 ] = 0.0;
		fVelocity[ 2 ] = 150.0;

		TeleportEntity( client, fVecOrigin, NULL_VECTOR, fVelocity );
		
		
	}
	
	jb_GiveEverything(client);
	
	// m_usSolidFlags 16
	// fixes player collisions
	// SetEntProp(client, Prop_Data, "m_usSolidFlags", 16);
}


public Action:ev_player_activate_fixstuff(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	showVGUIMenu(client, "info", 0);

	// FakeClientCommand(client, "cl_showpluginmessages 1");

	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			FakeClientCommand(i, "vmodenable 1\n"); //fix voice chat???
			SendConVarValue(i, FindConVar("sv_cheats"), "1");
		}
	}
}


public Action:ev_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new iClient = GetClientOfUserId(iUserId);

	// showScores[iClient] = 0;

	// decl String:strReason[50];
	// GetEventString(event, "reason", strReason, sizeof(strReason));
	// decl String:strName[50];
	// GetEventString(event, "name", strName, sizeof(strName));
	// decl String:strNetworkId[50];
	// GetEventString(event, "networkid", strNetworkId, sizeof(strNetworkId));


	// new Handle:hEvent = CreateEvent("player_disconnect");
	// SetEventInt(hEvent, "userid", iUserId);
	// SetEventString(hEvent, "reason", strReason);
	// SetEventString(hEvent, "name", strName);
	// SetEventString(hEvent, "networkid", strNetworkId);

	// SetEventBroadcast(event, bool:true);

	// FireEvent(hEvent, true);

	return Plugin_Continue;
}


public Action:ev_PlayerConnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// decl String:strName[50];
	// GetEventString(event, "name", strName, sizeof(strName));
	// new iIndex = GetEventInt(event, "index");
	// new iUserId = GetEventInt(event, "userid");
	//new iClient = GetClientOfUserId(iUserId);
	// decl String:strNetworkId[50];
	// GetEventString(event, "networkid", strNetworkId, sizeof(strNetworkId));
	// decl String:strAddress[50];
	// GetEventString(event, "address", strAddress, sizeof(strAddress));

	// ServerCommand("lua SetClientIpAddress(%d,\"%s\")", iIndex+1, strAddress);


	// new Handle:hEvent = CreateEvent("player_connect");
	// SetEventString(hEvent, "name", strName);
	// SetEventInt(hEvent, "index", iIndex);
	// SetEventInt(hEvent, "userid", iUserId);
	// SetEventString(hEvent, "networkid", strNetworkId);
	// SetEventString(hEvent, "address", "");

	// SetEventBroadcast(event, bool:true);

	// FireEvent(hEvent, true);

	return Plugin_Continue;
}


public Action:fTimer_drawAdverts(Handle:timer)
{
	advertTime = advertTime - 1;

	if (advertTime < 0) {
		
		advertTime = 10;
		curAdvert = curAdvert + 1;
		
		if (curAdvert == 3) //make this advert a bit longer...
		{
			advertTime = 20;
		}
		
		if (curAdvert > 3)
		{
			curAdvert = 0;
		}
	}

	if (curAdvert == 0) {
		SendMsg_HudMsg(0, 0, -1.0, 0.0, 0, 255, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Visit chat.facewan.com to chat with us!");
		

	} else if (curAdvert == 1) {
		SendMsg_HudMsg(0, 0, -1.0, 0.0, 0, 255, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Type 'buddha' into the console for godmode");

	} else if (curAdvert == 2) {
		SendMsg_HudMsg(0, 0, -1.0, 0.0, 0, 255, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Type 'noclip' into the console to fly");

	} else if (curAdvert == 3) {
		SendMsg_HudMsg(0, 0, -1.0, 0.0, 0, 255, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Press 'Switch Physgun modes' to equip the toolgun!\n(Default binding: 'C', check your options)");

	}
}


public Action:fTimer_keepFreeSlot(Handle:timer)
{
	int total = 0;
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i) == true)
		{
			total = total + 1;
		}
	}
	
	if (total > 30) {
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientInGame(i) && IsFakeClient(i))
			{
				KickClient(i, "Freeing slot...");
				break;
			}
		}
	}
}


public Action:fTimer_playerParentCheck(Handle:timer)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (Entity_GetParent(i) > 0 && Entity_GetCollisionGroup(i) != COLLISION_GROUP_IN_VEHICLE)
			{
				MoveType movetype = GetEntityMoveType(i);
				
				if (movetype == MOVETYPE_WALK) {
					SetEntityMoveType(i, MOVETYPE_NOCLIP);
				}
				
				float fVecOrigin[3];
				bool changed = false;
				GetEntPropVector(i, Prop_Data, "m_vecOrigin", fVecOrigin );
				
				if (fVecOrigin[0] > 512.0) {fVecOrigin[0] = 512.0; changed = true;}
				if (fVecOrigin[0] < -512.0) {fVecOrigin[0] = -512.0; changed = true;}
				
				if (fVecOrigin[1] > 512.0) {fVecOrigin[1] = 512.0; changed = true;}
				if (fVecOrigin[1] < -512.0) {fVecOrigin[1] = -512.0; changed = true;}
				
				if (fVecOrigin[2] > 512.0) {fVecOrigin[2] = 512.0; changed = true;}
				if (fVecOrigin[2] < -512.0) {fVecOrigin[2] = -512.0; changed = true;}
				
				if (changed == true)
				{
					SetEntPropVector(i, Prop_Data, "m_vecOrigin", fVecOrigin );
				}
				
				SendMsg_HudMsg(i, 1, -1.0, 0.75, 0, 255, 255, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "You are attached to something!\nPress Jump to detach!");
			}
		}
	}
}


public Action:fTimer_chatAdverts(Handle:timer)
{
	curAdvertChat = curAdvertChat + 1;
	
	if (curAdvertChat > 3) //make this advert a bit longer...
	{
		curAdvertChat = 0;
	}
	
	if (curAdvertChat == 0) {
		PrintToChatAll("\x01\x07FFFF00Say !buddha or !godmode for godmode - Say it again to disable");
		
	} else if (curAdvertChat == 1) {
		PrintToChatAll("\x01\x07FFFF00Visit chat.facewan.com to chat with us!");

	} else if (curAdvertChat == 2) {
		PrintToChatAll("\x01\x07FFFF00You can say !noclip to fly");

	} else if (curAdvertChat == 3) {
		PrintToChatAll("\x01\x07FFFF00Press 'Switch Physgun modes' to equip the toolgun (Default 'C', check your options)");

	}
}

