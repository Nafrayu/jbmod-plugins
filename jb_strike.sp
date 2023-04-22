public Plugin:myinfo =
{
	name = "jbmod - jbstrike gamemode",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


//static variables
int LaserCache = 0;
int HaloSprite = 0;
int gRoundTimer = 3;
int gRoundStage = 0;
int gRoundStageOverride = -1;


//gameplay variables
int PlayerFrozen[MAXPLAYERS + 1];
int PlayerTeam[MAXPLAYERS + 1];
int PlayerInBombsiteA[MAXPLAYERS + 1];
int PlayerInBombsiteB[MAXPLAYERS + 1];
new Handle:hTimer_GameLogic;
new Handle:g_Cvars[4] = { INVALID_HANDLE, ... };


#define CVAR_ROUNDTIME_SCORES 0
#define CVAR_ROUNDTIME_WARMUP 1
#define CVAR_ROUNDTIME_PLAY 2

#define ROUND_SCORES 0
#define ROUND_WARMUP 1
#define ROUND_PLAY 2

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
// #include <customkeyvalues>

#include "jb_includes/jb_lib.sp"
#include "jb_includes/SendKeyHintText.inc"
#include "jb_includes/SendMsg_HudMsg.inc"
#include "jb_strike/cmd.sp"
#include "jb_strike/stuff.sp"
#include "jb_strike/triggers.sp"


#pragma semicolon 1


public OnPluginStart()
{	
	RegAdminCmd("sm_jbs_nextstage", cmd_nextmode, ADMFLAG_GENERIC, "advance to next round stage");

	g_Cvars[CVAR_ROUNDTIME_SCORES] = CreateConVar("sm_jbs_time_scores", "5", "how long to show the scoreboard for? (seconds)", _, true, 1.0, true, 30.0);
	
	g_Cvars[CVAR_ROUNDTIME_WARMUP] = CreateConVar("sm_jbs_time_warmup", "10", "how long to warmup for? (seconds)", _, true, 1.0, true, 90000.0);
	
	g_Cvars[CVAR_ROUNDTIME_PLAY] = CreateConVar("sm_jbs_time_play", "150", "how long to play for? (seconds)", _, true, 1.0, true, 90000.0);
	
	HookEvent("player_spawn", ev_spawn, EventHookMode_Post);
	HookEvent("player_activate", ev_activate, EventHookMode_Post);	
	HookEvent("player_disconnect", ev_disconnect, EventHookMode_Pre);
	
	hTimer_GameLogic = CreateTimer(1.0, funcTimer_GameLogic, _, TIMER_REPEAT);
	
	
	/////////////////////////////////////////////////////////////////////////////
	// set up a new game every time the plugin reloads
	
	gRoundTimer = -1;
	gRoundStage = 0;
	gRoundStageOverride = ROUND_WARMUP;
	
	Everyone_RespawnFreezeShowScores(true, 0, 0);
	
	decl String:cmap[256];
	GetCurrentMap(cmap, 256);
	
	if (strncmp(cmap, "jbs_", 4, false) == 0)
	{
		int entity_index = MaxClients + 1; // Skip all client indexs...
		
		while((entity_index = FindEntityByClassname(entity_index, "trigger_multiple")) != -1)
		{
			SDKHook(entity_index, SDKHook_StartTouch, trigger_touchstart);
			SDKHook(entity_index, SDKHook_EndTouch, trigger_touchend);
		}
	}
	
	// int entity_index = MaxClients + 1; // Skip all client indexs...
	
	// while((entity_index = FindEntityByClassname(entity_index, "weapon_*")) != -1)
	// {
		// jb_RemoveEntity(ent);
	// }

	// entity_index = MaxClients + 1; // Skip all client indexs...

	// while((entity_index = FindEntityByClassname(entity_index, "item_*")) != -1)
	// {
		// jb_RemoveEntity(ent);
	// }
}


public OnPluginEnd()
{
	KillTimer(hTimer_GameLogic);
	
	decl String:cmap[256];
	GetCurrentMap(cmap, 256);
	
	// if (strncmp(cmap, "jbs_", 4, false) == 0)
	// {
	int entity_index = MaxClients + 1; // Skip all client indexs...
	
	while((entity_index = FindEntityByClassname(entity_index, "trigger_multiple")) != -1)
	{
		SDKUnhook(entity_index, SDKHook_StartTouch, trigger_touchstart);
		SDKUnhook(entity_index, SDKHook_EndTouch, trigger_touchend);
	}
	// }
}


public OnClientPutInServer(client) 
{
	PlayerFrozen[client] = false;
}


public OnEventShutdown()
{
	UnhookEvent("player_spawn", ev_spawn);
	UnhookEvent("player_activate", ev_activate);
	UnhookEvent("player_disconnect", ev_disconnect);
}


public Action:ev_spawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	// Client_RemoveAllWeapons(client);
	jb_GiveEverything(client);
}


public Action:ev_activate(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);	
}



public Action:ev_disconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);	
}


public Action:funcTimer_GameLogic(Handle:timer)
{
//this function executes every second

	gRoundTimer = gRoundTimer - 1;
	
	// count online players
	int playersOnline = 0;
	
	for (new i=1; i<=MaxClients; i++) {
		if (IsClientInGame(i) && IsClientInGame(i))
		{
			playersOnline = playersOnline + 1;
			
			if (gRoundStage == ROUND_SCORES) {
				showVGUIMenu(i, "scores", 1);
			}
		}
	}
	
	// we are alone
	// prevent the game from advancing :(
	if (playersOnline == 1) {
		gRoundStageOverride = ROUND_WARMUP;
	}
		
	if (gRoundTimer <= 0)
	// time to change mode
	{
		if (gRoundStage == ROUND_SCORES) {
			//we have been showing the scoreboard, go back to warmup
			gRoundStage = ROUND_WARMUP;
			gRoundTimer = GetConVarInt(g_Cvars[CVAR_ROUNDTIME_WARMUP]);
			
		} else if (gRoundStage == ROUND_WARMUP) {
			//we have been warming up, start playing
			gRoundStage = ROUND_PLAY;
			gRoundTimer = GetConVarInt(g_Cvars[CVAR_ROUNDTIME_PLAY]);
			
		} else if (gRoundStage == ROUND_PLAY) {
			//we have been playing, show the scoreboard
			gRoundStage = ROUND_SCORES;
			gRoundTimer = GetConVarInt(g_Cvars[CVAR_ROUNDTIME_SCORES]);
		}		
		
		// did something override what our next round stage is? (players leaving for example)
		// if yes, accept the override and reset the "override flag" so it can be used again
		if (gRoundStageOverride > -1 && gRoundStage != ROUND_SCORES) {
			gRoundStage = gRoundStageOverride;
			gRoundStageOverride = -1;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//round end, show scores, freeze everyone
		if (gRoundStage == ROUND_SCORES) {
			
			Everyone_RespawnFreezeShowScores(false, 1, 1);
		}
		
		//////////////////////////////////////////////////////////////////////////////
		// we finally have enough players!
		if (gRoundStage == ROUND_WARMUP && playersOnline > 1) {
			gRoundStage = ROUND_PLAY;
			gRoundTimer = GetConVarInt(g_Cvars[CVAR_ROUNDTIME_PLAY]);

			Everyone_RespawnFreezeShowScores(true, 0, 0);
		}
		
		//////////////////////////////////////////////////////////////////////////////
		// the server became empty :(
		if (gRoundStage == ROUND_WARMUP)
		{
			Everyone_RespawnFreezeShowScores(true, 0, 0);
			
			gRoundTimer = 5;
		}
	}
	
	SendMsg_HudMsg(0, 2, 0.0, 0.5, 255, 255, 0, 0, 0, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "[PUBLIC BETA]");
	
	// stock SendMsg_HudMsg(client, channel, 
		// Float:x, Float:y, 
		// aRclr, aGclr, aBclr, aTclr, 
		// bRclr, bGclr, bBclr, bTclr, 
		// effect, 
		// Float:fadein, Float:fadeout, 
		// Float:holdtime, Float:fxtime, 
		// const String:szMsg[]
		// const String:format[], any:...)

	char timeFormated[256];
	FormatTime(timeFormated, sizeof(timeFormated), "%M:%S", gRoundTimer);
		
	if (gRoundStage == ROUND_SCORES) {
		SendMsg_HudMsg(0, 1, -1.0, 0.8, 0, 255, 255, 0, 0, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Waiting for next round...");
		
	} else if (gRoundStage == ROUND_WARMUP) {
		SendMsg_HudMsg(0, 1, -1.0, 0.8, 0, 255, 255, 0, 0, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Waiting for players...");
		
	} else if (gRoundStage == ROUND_PLAY) {
		SendMsg_HudMsg(0, 1, -1.0, 0.8, 0, 255, 255, 0, 0, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Plant the bomb!\nTime left: %s", timeFormated);
	}

}


public Action:OnPlayerRunCmd(
	client, &buttons, &impulse, Float:vel[3], Float:angles[3],
	&weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{	
	if (PlayerFrozen[client]) {
		vel[0] = 0.0;
		vel[1] = 0.0;
		vel[2] = 0.0;
		
		if (buttons & IN_ATTACK) { buttons = buttons & ~IN_ATTACK;  return Plugin_Changed; }
		if (buttons & IN_ATTACK2) { buttons = buttons & ~IN_ATTACK2;  return Plugin_Changed; }
		
		if (buttons & IN_USE) { buttons = buttons & ~IN_USE;  return Plugin_Changed; }
		
		if (buttons & IN_FORWARD) { buttons = buttons & ~IN_FORWARD;  return Plugin_Changed; }
		if (buttons & IN_BACK) { buttons = buttons & ~IN_BACK;  return Plugin_Changed; }
		if (buttons & IN_MOVELEFT) { buttons = buttons & ~IN_MOVELEFT;  return Plugin_Changed; }
		if (buttons & IN_MOVERIGHT) { buttons = buttons & ~IN_MOVERIGHT;  return Plugin_Changed; }
	}
	
	return Plugin_Continue;
}




public OnEntityCreated(entity, const String:classname[])
{
	if (StrContains(classname, "trigger_multiple", bool:false) != -1)
	{
		PrintToConsoleAll("\t[JBStrike] new trigger! %i", entity);
		SDKHook(entity, SDKHook_StartTouch, trigger_touchstart);
		SDKHook(entity, SDKHook_EndTouch, trigger_touchend);
	}
}




