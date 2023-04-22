public Plugin:myinfo =
{
	name = "jbmod security",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


new LaserCache = 0;
// new HaloSprite = 0;
int g_totalcommands[MAXPLAYERS+1];
int g_last_impulse[MAXPLAYERS+1];
int g_next_entfire[MAXPLAYERS+1];
int g_next_vehicle[MAXPLAYERS+1];
int g_next_remove[MAXPLAYERS+1];
// new String:g_Playerwheels[MAXPLAYERS+1][256];
int g_player_useridcache[MAXPLAYERS+1];


new Handle:antiAirboatTimer;
new Handle:physSlowTimer;
new Handle:hTimer_DefuseEnts;
new Handle:h_FloodFiller;
// new Handle:hookPickup;
StringMap entity_whitelisted;
new ArrayList:g_propowner;


#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_tempents>
#include <sdktools_sound>
#include <sdkhooks>
#include <regex>
#include <entity_prop_stocks>
#include <dhooks>
#include <smlib>


#include "jb_includes/jb_lib.sp"
#include "jb_includes/SendKeyHintText.inc"
#include "jb_includes/SendMsg_HudMsg.inc"
#include "jb_security/cmd.sp"
#include "jb_security/lib.sp"
#include "jb_security/propprotection.sp"


#pragma semicolon 1


public OnPluginStart()
{
	PrintToConsoleAll("jb s start 555");
	// HookEntityOutput("prop_physics", "OnKilled", OutputHook);
	// HookEntityOutput("prop_physics_multiplayer", "OnKilled", OutputHook);
	// HookEntityOutput("prop_vehicle_airboat", "OnKilled", OutputHook);
	// HookEntityOutput("prop_vehicle_jeep", "OnKilled", OutputHook);
	// HookEntityOutput("prop_vehicle_prisoner_pod", "OnKilled", OutputHook);
	
	// new Handle:temp = LoadGameConfigFile("dhooks.games/game.jbmod");
	// if(temp == INVALID_HANDLE)
	// {
		// SetFailState("Why you no has gamedata?");
	// }

	// new offset;
	
	// CPlayerPickupController::Use(CBaseEntity*, CBaseEntity*, USE_TYPE, float)
	// CPlayerPickupControllerUse
	// void CGrabController::AttachEntity( CBasePlayer *pPlayer, CBaseEntity *pEntity, IPhysicsObject *pPhys, bool bIsMegaPhysCannon, const Vector &vGrabPosition, bool bUseGrabPosition )
	
	// offset = GameConfGetOffset(temp, "CPlayerPickupControllerUse");
	// hookPickup = DHookCreate(offset, HookType_Entity, ReturnType_Void, ThisPointer_CBaseEntity, myPickupHook);
	// DHookAddParam(hookPickup, HookParamType_CBaseEntity);
	// DHookAddParam(hookPickup, HookParamType_CBaseEntity);
	// DHookAddParam(hookPickup, HookParamType_Int);
	// DHookAddParam(hookPickup, HookParamType_Float);

	RegServerCmd("sm_addcheat", addcheat, "Adds the cheat flag to a command");
	RegServerCmd("sm_removecheat", removecheat, "Removes the cheat flag from a command");
	
	RegAdminCmd("removebymodel", cmd_removebymodel, ADMFLAG_GENERIC, "remove ents by model (dangerous)");	
	
	// AddCommandListener(fuck_it, "ai_test_los"           );
	// AddCommandListener(fuck_it, "dbghist_dump"          );
	// AddCommandListener(fuck_it, "dump_entity_sizes"     );
	// AddCommandListener(fuck_it, "dump_globals"          );
	// AddCommandListener(fuck_it, "dump_terrain"          );
	// AddCommandListener(fuck_it, "dumpcountedstrings"    );
	// AddCommandListener(fuck_it, "dumpentityfactories"   );
	// AddCommandListener(fuck_it, "dumpeventqueue"        );
	// AddCommandListener(fuck_it, "dbghist_addline"       );
	// AddCommandListener(fuck_it, "dbghist_dump"       );	
	// AddCommandListener(fuck_it, "es_version"            );
	// AddCommandListener(fuck_it, "groundlist"            );
	// AddCommandListener(fuck_it, "listmodels"            );
	// AddCommandListener(fuck_it, "mem_dump"              );
	// AddCommandListener(fuck_it, "mp_dump_timers"        );
	// AddCommandListener(fuck_it, "npc_ammo_deplete"      );
	// AddCommandListener(fuck_it, "npc_heal"              );
	// AddCommandListener(fuck_it, "npc_speakall"          );
	// AddCommandListener(fuck_it, "npc_thinknow"          );
	// AddCommandListener(fuck_it, "physics_budget"        );
	// AddCommandListener(fuck_it, "physics_debug_entity"  );
	// AddCommandListener(fuck_it, "physics_report_active" );
	// AddCommandListener(fuck_it, "physics_select"        );
	// AddCommandListener(fuck_it, "report_entities"       );
	// AddCommandListener(fuck_it, "report_touchlinks"     );
	// AddCommandListener(fuck_it, "snd_digital_surround"  );
	// AddCommandListener(fuck_it, "snd_restart"           );
	// AddCommandListener(fuck_it, "soundlist"             );
	// AddCommandListener(fuck_it, "soundscape_flush"      );
	// AddCommandListener(fuck_it, "wc_update_entity"      );	
	// AddCommandListener(fuck_it, "npc_kill"              );
	// AddCommandListener(fuck_it, "test_createentity"     );	
	// AddCommandListener(fuck_it, "prop_dynamic_create"   );	
	// AddCommandListener(fuck_it, "test_randomplayerposition");
	// AddCommandListener(fuck_it, "ai_nodes");
	// AddCommandListener(fuck_it, "ai_show_connect");
	// AddCommandListener(fuck_it, "ai_show_graph_connect");
	// AddCommandListener(fuck_it, "ai_show_hull");
	// AddCommandListener(fuck_it, "ai_show_visibility");
	// AddCommandListener(fuck_it, "air_density");
	// AddCommandListener(fuck_it, "bloodspray");
	// AddCommandListener(fuck_it, "create_flashlight");
	// AddCommandListener(fuck_it, "dumpgamestringtable");
	// AddCommandListener(fuck_it, "ent_pause");
	// AddCommandListener(fuck_it, "explodevector");
	// AddCommandListener(fuck_it, "fadein");
	// AddCommandListener(fuck_it, "fadeout");
	// AddCommandListener(fuck_it, "firetarget");
	// AddCommandListener(fuck_it, "global_set");
	// AddCommandListener(fuck_it, "kdtree_test");
	// AddCommandListener(fuck_it, "killvector");
	// AddCommandListener(fuck_it, "npc_reset");
	// AddCommandListener(fuck_it, "npc_squads");
	// AddCommandListener(fuck_it, "setmodel");
	// AddCommandListener(fuck_it, "shake");
	// AddCommandListener(fuck_it, "wc_air_edit_further");
	// AddCommandListener(fuck_it, "wc_create");
	// AddCommandListener(fuck_it, "wc_destroy");
	// AddCommandListener(fuck_it, "wipe_nav_attributes");
	
	// AddCommandListener(fuck_it, "spec_next");
	// AddCommandListener(fuck_it, "spec_prev");
	
	// AddCommandListener(fuck_it, "setang");
	// AddCommandListener(fuck_it, "setpos");
	// AddCommandListener(fuck_it, "setpos_exact");
	// AddCommandListener(fuck_it, "ent_messages");	
	// AddCommandListener(fuck_it, "cl_playermodel");
	
	// AddCommandListener(fuck_it, "give");
	
	// AddCommandListener(fuck_it, "npc_create_aimed");
	
	AddCommandListener(fix_entremove, "ent_remove");
	AddCommandListener(fix_entremove, "ent_remove_all");	
		
	AddCommandListener(ent_create_override, "npc_create");
	AddCommandListener(ent_create_override, "ent_create");
	AddCommandListener(prop_physics_create_override, "prop_physics_create");
	
	AddCommandListener(fix_killbind, "kill");
	
	AddCommandListener(make_admin_only, "ent_teleport");
	AddCommandListener(make_admin_only, "setpos");
	AddCommandListener(make_admin_only, "setpos_exact");
	
	AddCommandListener(bot_create_override, "bot");
	
	AddCommandListener(ch_createairboat_override, "ch_createairboat");
	AddCommandListener(ch_createjeep_override, "ch_createjeep");
	AddCommandListener(ch_createjalopy_override, "ch_createjalopy");
//	RegConsoleCmd("ch_createpod", ch_createpod_override);
		
	AddCommandListener(cmd_cooldown, "");
	// AddCommandListener(cmd_createfirewall, "");
	
	HookEvent("player_disconnect", ev_disconnect_cleargravitypellets, EventHookMode_Pre);
	HookEvent("player_disconnect", ev_disconnect_propprotection_disconnect, EventHookMode_Pre);
	HookEvent("player_disconnect", ev_disconnect_entremoved, EventHookMode_Pre);
	
	physSlowTimer = CreateTimer(4.0, physSlowFunc, _, TIMER_REPEAT);

	antiAirboatTimer = CreateTimer(0.0, antiAirboatFunc, _, TIMER_REPEAT);
	
	h_FloodFiller = CreateTimer(1.0, fTimer_FloodFiller, _, TIMER_REPEAT);
	
	// CreateTimer(5.0, gm_wheel_model_think, _, TIMER_REPEAT);
	
	for (new i=1; i<=MaxClients; i++)
	{
		g_last_impulse[i] = 0;
		g_next_entfire[i] = 0;
		g_next_vehicle[i] = 0;
		g_next_remove[i] = 0;
	}
	
	entity_whitelisted = CreateTrie();
	
	new Handle:myFile = OpenFile("jbmod-ent-whitelist.txt", "r");
	
	char buf[256];
	
	while (ReadFileLine(myFile, buf, sizeof(buf)))
	{
		ReplaceString(buf, sizeof(buf), "\r", "", bool:false);
		ReplaceString(buf, sizeof(buf), "\n", "", bool:false);
		ReplaceString(buf, sizeof(buf), " ", "", bool:false);
		
		if (StrContains(buf, "//", bool:false) != -1)
		{
			ReplaceString(buf, sizeof(buf), "//", "", bool:false);
			SetTrieValue(entity_whitelisted, buf, bool:false, bool:true);
		} else {
			SetTrieValue(entity_whitelisted, buf, bool:true, bool:true);
		}

		// PrintToServer("%s", buf);
	}

	g_propowner = new ArrayList(64, 2048);
	
	for (new i=1; i<=MaxClients; i++)
	{		
		if (IsClientInGame(i))
		{
			SDKHook(i, SDKHook_PostThinkPost, player_fixAnimationPlayback);
			SDKHook(i, SDKHook_PostThink, player_physgunprotection);
			g_player_useridcache[i] = GetClientUserId(i);
		}
	}		
}


public OnClientPutInServer(client)
{
	// SDKHook_PreThink
	// SDKHook_PreThinkPost
	// SDKHook_Think
	// SDKHook_ThinkPost
	// SDKHook_PostThink
	// SDKHook_PostThinkPost
	
	SDKHook(client, SDKHook_PostThinkPost, player_fixAnimationPlayback);
	SDKHook(client, SDKHook_PostThink, player_physgunprotection);
}


public OnPluginEnd()
{
	KillTimer(antiAirboatTimer);
	KillTimer(physSlowTimer);
	KillTimer(h_FloodFiller);
	KillTimer(hTimer_DefuseEnts);
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i))
		{
			SDKUnhook(i, SDKHook_PostThinkPost, player_fixAnimationPlayback);
			SDKUnhook(i, SDKHook_PostThink, player_physgunprotection);
		}
	}
}


public OnEventShutdown()
{
	UnhookEvent("player_disconnect", ev_disconnect_cleargravitypellets);
	UnhookEvent("player_disconnect", ev_disconnect_propprotection_disconnect);
	UnhookEvent("player_disconnect", ev_disconnect_entremoved);
}



public OnMapStart()
{
	// PrintToServer("_________________START");
	CreateTimer(0.0, fixmap, _, TIMER_FLAG_NO_MAPCHANGE	);
	// CreateTimer(0.2, fTimer_defuseEnts, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE	);
	hTimer_DefuseEnts = CreateTimer(1.0, fTimer_defuseEnts, _, TIMER_REPEAT);
	LaserCache = PrecacheModel("sprites/laserbeam.spr");
	// HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
}


void item_item_crate_check(int ent)
{
	// DEFINE_KEYFIELD( m_CrateType, FIELD_INTEGER, "CrateType" ),	
	// DEFINE_KEYFIELD( m_strItemClass, FIELD_STRING, "ItemClass" ),	
	// DEFINE_KEYFIELD( m_nItemCount, FIELD_INTEGER, "ItemCount" ),	
	// DEFINE_KEYFIELD( m_strAlternateMaster, FIELD_STRING, "SpecificResupply" ),	
	// DEFINE_KEYFIELD( m_CrateAppearance, FIELD_INTEGER, "CrateAppearance" ),
	// DEFINE_INPUTFUNC( FIELD_VOID, "Kill", InputKill ),
	// DEFINE_OUTPUT( m_OnCacheInteraction, "OnCacheInteraction" ),
	
	int ents_total = GetEntityCount();
	
	PrintToServer("ents %i", ents_total);
	
	int entity_index = MaxClients + 1; // Skip all client indexs...
	
	while((entity_index = FindEntityByClassname(entity_index, "item_item_crate")) != -1)
	{
		if (entity_index != ent) {
			if (HasEntProp(ent, Prop_Data, "m_nItemCount"))
			{
				int ents_crate = GetEntProp(entity_index, Prop_Data, "m_nItemCount");
				
				ents_total = ents_total + ents_crate;
				
				if (ents_total > 2000)
				{
					jb_RemoveEntity(entity_index);
				}
			}
		}
	}
	
	if (HasEntProp(ent, Prop_Data, "m_nItemCount"))
	{
		int ents_crate = GetEntProp(ent, Prop_Data, "m_nItemCount");

		if (ents_total + (ents_crate * 2) > 1500) {
			jb_RemoveEntity(ent);
		} else if (ents_crate > 20) {
			SetEntProp(ent, Prop_Data, "m_nItemCount", 20);
		}
	}
}


void gravity_pellet_check(int ent)
{
	int entity_index = MaxClients + 1; // Skip all client indexs...
	int total_pellets = 1;

	while ((entity_index = FindEntityByClassname(entity_index, "gravity_pellet")) != -1)
	{
		if (entity_index != ent)
		{			
			if (GetEntPropEnt(entity_index, Prop_Send, "m_hOwnerEntity") == GetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity"))
			{
				total_pellets = total_pellets + 1;
				
				if (total_pellets > 2)
				{
					jb_RemoveEntity(entity_index);
				}
			}
		}
	}
}


public OnEntityCreated(ent, const String:classname[])
{
	if(strcmp(classname, "item_item_crate", false) == 0)
	{
        SDKHook(ent, SDKHook_SpawnPost, item_item_crate_check);
	}
	
	if(strcmp(classname, "gravity_pellet", false) == 0)
	{
		SDKHook(ent, SDKHook_SpawnPost, gravity_pellet_check);
	}
	
	// if(strcmp(classname, "player", false) == 0)
	// {
		// SDKHook(ent, SDKHook_SpawnPost, newPlayerCreated);
	// }
}


public OnEntityDestroyed(ent)
{
	if (ent > 0 && ent <= 2048)
	{
		SetArrayString(g_propowner, ent, "");
	}
}


// public OnGameFrame()
// {

	// for (new i=1; i<=MaxClients; i++)
	// {
		// if (IsClientInGame(i))
		// {

		// }
	// }
// }


public Action:newPlayerCreated(ent)
{
	g_player_useridcache[ent] = GetClientUserId(ent);
	return Plugin_Continue;
}


//int CCSPlayer::OnTakeDamage(CTakeDamageInfo const&)
// public MRESReturn:myPickupHook(pThis, Handle:hReturn, Handle:hParams)
// {
	// PrintToServer("picking up %i", pThis);
	
    // PrintToServer("DHooksHacks = Victim %i, Attacker %i, Inflictor %i, Damage %f", pThis, DHookGetParamObjectPtrVar(hParams, 1, 40, ObjectValueType_Ehandle), DHookGetParamObjectPtrVar(hParams, 1, 36, ObjectValueType_Ehandle), DHookGetParamObjectPtrVar(hParams, 1, 48, ObjectValueType_Float));
    
    // if(pThis <= MaxClients && pThis > 0 && !IsFakeClient(pThis))
    // {
        // DHookSetParamObjectPtrVar(hParams, 1, 48, ObjectValueType_Float, 0.0);
        // PrintToChat(pThis, "Pimping your hp");
    // }
	// return MRES_Supercede;
// }

public Action player_fixAnimationPlayback( int client )
{
	if (GetEntPropFloat(client, Prop_Send, "m_flPlaybackRate") > 11.9)
	{
		SetEntPropFloat(client, Prop_Send, "m_flPlaybackRate", 11.9);
	}
	return Plugin_Continue;
}

public Action player_physgunprotection( int client )
{

	int buttons = GetClientButtons(client);
	
	if ((buttons & IN_ATTACK) || (buttons & IN_ATTACK2) || (buttons & IN_RELOAD))
	{		
		char wep[32];
		Client_GetActiveWeaponName(client, wep, 32);

		if (StrEqual(wep, "weapon_physgun") == true)
		{
			int weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
			int pickup = GetEntPropEnt(weapon, Prop_Data, "m_hObject");
			
			if (pickup == -1)
			{
				new Float:plypos[3];
				new Float:endpos[3];
				new Float:angles[3];
				GetClientAbsOrigin(client, plypos);
				GetClientEyeAngles(client, angles);
				new ent = TracePlayerAngles(client, angles, 4096.0, endpos);
				
				// PrintToConsole(client, "pickup %i", pickup);

				if (ent > 0) {
					// new String:cname[256];
					// Entity_GetClassName(ent, cname, sizeof(cname));
					
					// if (!EntityIsWhitelisted(cname) &&) {
					char steamid[64];
					GetClientAuthId(client, AuthId_Steam3, steamid, sizeof(steamid));
					
					char owner[64];
					int hasowner = GetArrayString(g_propowner, ent, owner, 64);
					
					if (hasowner > 0 && StrEqual(owner, steamid) != true)
					{
						//disable buttons
						if (buttons & IN_ATTACK) {buttons = buttons & ~IN_ATTACK;}
						if (buttons & IN_ATTACK2) {buttons = buttons & ~IN_ATTACK2;}
						if (buttons & IN_RELOAD) {buttons = buttons & ~IN_RELOAD;}
						
						jb_toolgun_effect_deny(client, ent, plypos, endpos);
						
						Client_SetButtons(client, buttons);
					} 
				}
			}
		}
	}
	
	return Plugin_Continue;
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
	if (!IsValidEdict(client) || !IsValidEntity(client))
	{	
		return Plugin_Stop;
	}

	if (impulse == 81) {
		FakeClientCommand(client, "give weapon_cubemap");
		impulse = 0;
		return Plugin_Changed;
		
	} else if (impulse == 82) {
		// FakeClientCommand(client, "ch_createjeep");
		impulse = 0;
		return Plugin_Changed;
		
	} else if (impulse == 83) {
		// FakeClientCommand(client, "ch_createairboat");
		impulse = 0;
		return Plugin_Changed;
		
	} else if (impulse == 100) {
		return Plugin_Continue;
		
	} else if (impulse == 101) {
		jb_GiveEverything(client);
		return Plugin_Changed;
		
	} else if (impulse == 200) {
		return Plugin_Continue;
		
	} else if (impulse == 201) {
		return Plugin_Continue;
		
	} else if (impulse == 203) {
		impulse = 0;
		
		new Float:plypos[3];
		new Float:endpos[3] = {0.0, 0.0, 0.0};
		GetClientAbsOrigin(client, plypos);
		new ent = TracePlayerAngles(client, angles, 4096.0, endpos);
		
		new String:cname[256];
		Entity_GetClassName(ent, cname, sizeof(cname));

		if (
			(EntityIsWhitelisted(cname) && Entity_GetHammerId(ent) == 0
			&& strcmp(cname, "prop_combine_ball", false) != 0)
		|| (
			(strcmp(cname, "prop_vehicle_airboat", false) == 0)
			|| (strcmp(cname, "prop_vehicle_jeep", false) == 0)
			|| (strcmp(cname, "prop_vehicle_prisoner_pod", false) == 0)
		)
		) {
			jb_toolgun_effect(client, ent, plypos, endpos);
			PrintToConsoleAll("\t[JBMod] %L impulse 203 (deleting %s)", client, cname);
			// jb_RemoveEntity(ent);
			AcceptEntityInput(ent, "kill");
			
		}
		
		return Plugin_Changed;
		
	}

	if (buttons & IN_JUMP || (buttons & IN_WALK && buttons & IN_USE))
	{
		if (Entity_GetParent(client) > 0 && Entity_GetCollisionGroup(client) != COLLISION_GROUP_IN_VEHICLE)
		{
			Entity_ClearParent(client);
			SetEntityMoveType(client, MOVETYPE_WALK);
		}
	}

	// if (buttons & IN_ATTACK && buttons & IN_USE)
	// {
		// buttons = buttons & ~IN_USE;
		// return Plugin_Changed;
	// }
	
	
	// PrintToConsole(client, "------------ GOT IMPULSE %i", impulse);
	// impulse = 0;
	return Plugin_Continue;
}


// public Action:gm_wheel_model_think(Handle:timer) {
    // for (new i=1; i<=MaxClients; i++)
    // {
        // if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
        // {
            // QueryClientConVar(i, "cl_playermodel", ClientConVar, i);
        // }
    // }
// }


// public ClientConVar(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[]) {
    // if (strcmp(cvarName, "cl_playermodel", false) == 0)
    // {
        // if (strcmp(cvarValue, g_Playerwheels[client]) != 0)
        // {
            // strcopy(g_Playerwheels[client], 256, cvarValue);

            // if (StrContains(cvarValue, "..", bool:false) != -1
            // || StrContains(cvarValue, "_gesture", bool:false) != -1
            // || StrContains(cvarValue, "_anim", bool:false) != -1
            // || StrContains(cvarValue, "_gst", bool:false) != -1
            // || StrContains(cvarValue, "_pst", bool:false) != -1
            // || StrContains(cvarValue, "_shd", bool:false) != -1
            // || StrContains(cvarValue, "_ss", bool:false) != -1
            // || StrContains(cvarValue, "_posture", bool:false) != -1
			// || StrContains(cvarValue, "skybox", bool:false) != -1
            // || StrContains(cvarValue, "_anm", bool:false) != -1
            // || StrContains(cvarValue, "ghostanim", bool:false) != -1
            // || StrContains(cvarValue, "_paths", bool:false) != -1
            // || StrContains(cvarValue, "_shared", bool:false) != -1
            // || StrContains(cvarValue, "maps", bool:false) != -1
            // || StrContains(cvarValue, ".bsp", bool:false) != -1
			// || StrContains(cvarValue, ".vtf", bool:false) != -1
			// || StrContains(cvarValue, ".vmt", bool:false) != -1
			// || StrContains(cvarValue, ".spr", bool:false) != -1
            // || FileExists(cvarValue, bool:true) == false)
            // {
				//cl_playermodel models/player/alyx.mdl
                // ClientCommand(client, "cl_playermodel models/player/alyx.mdl");
                // SetClientInfo(client, "cl_playermodel", "models/player/alyx.mdl");
				// ClientCommand(client, "aaaaaaaaaaaa models/player/alyx.mdl");
            // }
            // else
            // {
                // SetClientInfo(client, "cl_playermodel", cvarValue);
            // }
        // }
    // }
// }


public Action:fTimer_defuseEnts(Handle:timer)
{

	int pellet = -1;
	
	while ((pellet = FindEntityByClassname(pellet, "gravity_pellet")) != INVALID_ENT_REFERENCE)
	{
		if (!IsValidEntity(GetEntPropEnt(pellet, Prop_Data, "m_hOwnerEntity")))
		{
			jb_RemoveEntity(pellet);
		}
	} 
	
	
	float fOrigin[3];
	
	for (new i = 1; i < GetMaxEntities(); i++)
	{
		if (IsValidEntity(i) && HasEntProp(i, Prop_Send, "m_vecOrigin"))
		{
			GetEntPropVector(i, Prop_Send, "m_vecOrigin", fOrigin);
			
			if (
			   fOrigin[0] < -16000.0 || fOrigin[0] > 16000.0
			|| fOrigin[1] < -16000.0 || fOrigin[1] > 16000.0
			|| fOrigin[2] < -16000.0 || fOrigin[2] > 16000.0
			)
			{
				new String:cname[256];
				Entity_GetClassName(i, cname, sizeof(cname));

				PrintToServer("defusing! %i %s (%f,%f,%f)", i, cname, fOrigin[0], fOrigin[1], fOrigin[2]);
				TeleportEntity(i, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0}, Float:{0.0,0.0,0.0});

				// jb_RemoveEntity(i);
			}
		}
	}
}


public Action:fixmap(Handle:timer)
{
	// ServerCommand("ent_keyvalue 32177 OnPressed !self,kill");
	// ServerCommand("ent_keyvalue 79137 OnPressed !self,kill");
	
	// ServerCommand("ent_keyvalue 32177 OnDamaged !self,kill");
	// ServerCommand("ent_keyvalue 79137 OnDamaged !self,kill");
		
	// ServerCommand("ent_remove_all prop_vehicle_crane");
	// ServerCommand("ent_remove_all env_spark");
	// ServerCommand("ent_remove_all ambient_generic");
	// ServerCommand("ent_remove_all env_sprite");
	// ServerCommand("ent_remove_all env_flare");
	// ServerCommand("ent_remove_all func_brush");
	
	ServerCommand("ent_keyvalue Tele1 spawnflags 15");

	decl String:cmap[256];
	GetCurrentMap(cmap, 256);
	
	// new entity = -1;
	// while ((entity = FindEntityByClassname(entity, "*")) != INVALID_ENT_REFERENCE)
	// {
		// if (GetEntProp(entity, Prop_Data, "m_iHammerID") == 35986)
		// {
			// break;
		// }
	// } 
	
	if (
	StrContains(cmap, "jp_buildingsblocks") != -1
	|| StrContains(cmap, "freewireconstructblocks") != -1
	)
	{
		ServerCommand("ent_remove canspawn");
		ServerCommand("ent_remove Rocketspawn");
		ServerCommand("ent_remove Telesound");
		
		for (new i=1; i<=GetEntityCount(); i++)
		{
			if (IsValidEntity(i))
			{
				new String:class1[256];
				GetEntityClassname(i, class1, 256);
				// PrintToServer("%i - %i", i, Entity_GetSpawnFlags(i));
				if (StrEqual(class1, "func_button", false))
				{
					if (Entity_GetSpawnFlags(i) == 1537) { // DONTMOVE + USE_ACTIVATES + DAMAGE_ACTIVATES
						// PrintToServer("fixed button %i - %i", i, Entity_GetSpawnFlags(i));
						Entity_SetSpawnFlags(i, 1025); // DONTMOVE + USE_ACTIVATES
					}
					//DispatchKeyValue(entity, "targetname", orignalTargetName);
					
				}
			}
		}
	}
}


//just disallow command
public Action:fuck_it(client, const String:command[], argc) {
	if (client != 0) {
		PrintToConsole(client, "-----------------------------------");
		PrintToConsole(client, "-- COMMAND NOT ALLOWED: %s (client %i) - IF THIS MESSAGE APPEARS IN ERROR", command, client);
		PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
		PrintToConsole(client, "-- i might whitelist the command accordingly");
		PrintToConsole(client, "-----------------------------------");
	}
	return Plugin_Stop;
}


public Action:make_admin_only(client, const String:command[], argc)
{
	if(GetUserAdmin(client) != INVALID_ADMIN_ID) {return Plugin_Continue;}
	
	PrintToConsole(client, "-----------------------------------");
	PrintToConsole(client, "-- COMMAND NOT ALLOWED: %s (client %i) - IF THIS MESSAGE APPEARS IN ERROR", command, client);
	PrintToConsole(client, "-- CONTACT ME WITH THE COMMAND: steamcommunity.com/id/nafrayu or Nafrayu#0001 on Discord");
	PrintToConsole(client, "-- i might whitelist the command accordingly");
	PrintToConsole(client, "-----------------------------------");
	return Plugin_Stop;
}


public Action:fix_killbind(client, const String:command[], argc)
{
	if (argc >= 1)	
	{
		return Plugin_Stop;
	}
}


new Float:lastEngine = 0.0;
new Float:lastTicked = 0.0;

public Action:physSlowFunc(Handle:timer)
{
	// PrintToServer("----%f", GetEngineTime());
	// PrintToServer("%f", GetTickedTime());
	
	new Float:diffEngine = GetEngineTime() - lastEngine;
	new Float:diffTicked = GetTickedTime() - lastTicked;
	
	new Float:totalDiff = diffEngine - diffTicked;
	
	lastEngine = GetEngineTime();
	lastTicked = GetTickedTime();
	
	if (totalDiff > 0.2) {
		PrintToServer("------- slow: %f", totalDiff);
		
		for (new i=1; i<=2048; i++)
		{
			if (IsValidEntity(i) && HasPhysics(i))
			{
				Phys_Sleep(i);
				
				// break;
			}
		}
	}
}


public Action:antiAirboatFunc(Handle:timer)
{
	new airboats = 0;
	new jeeps = 0;
	new ragdolls = 0;
	new helis = 0;
	new npcs = 0;
	new particlesys = 0;
	new scheiss = 0;

	for (new i=1; i<=GetEntityCount(); i++)
	{
		if (IsValidEntity(i) && Entity_GetParent(i) < 1)
		{
			char class1[32];
			GetEntityClassname(i, class1, sizeof(class1));

			if (StrContains(class1, "npc_") != -1)
			{
				npcs++;
				
				if (npcs > 16)
				{
					PrintToServer("Removing npc %i %s", i, class1);
					jb_RemoveEntity(i);
					break;
				}
			}
			
			if (StrEqual(class1, "prop_vehicle_airboat", false))
			{
				airboats++;
			}
			if (StrEqual(class1, "prop_vehicle_jeep", false))
			{
				jeeps++;
			}
			if (StrEqual(class1, "prop_ragdoll", false))
			{
				ragdolls++;
			}
			if (StrEqual(class1, "npc_helicopter", false))
			{
				helis++;
			}
			if (StrEqual(class1, "info_particle_system", false))
			{
				particlesys++;
			}
			if (StrEqual(class1, "gib", false)
			|| StrEqual(class1, "helicopter_chunk", false))
			{
				scheiss++;
			}
		}
	}
	
	if (airboats > 16) {
		PrintToServer("ent_remove_all prop_vehicle_airboat");
		ServerCommand("ent_remove_all prop_vehicle_airboat");
	}
	
	if (jeeps > 16) {
		PrintToServer("ent_remove_all prop_vehicle_jeep");
		ServerCommand("ent_remove_all prop_vehicle_jeep");
	}
	
	if (ragdolls > 16) {
		PrintToServer("ent_remove_all prop_ragdoll");
		ServerCommand("ent_remove_all prop_ragdoll");
	}
	
	if (helis > 1) {
		PrintToServer("ent_remove_all npc_helicopter");
		ServerCommand("ent_remove_all npc_helicopter");
	}
	
	if (particlesys > 2) {
		PrintToServer("ent_remove_all info_particle_system");
		ServerCommand("ent_remove_all info_particle_system");
	}
	
	if (scheiss > 0) {
		PrintToServer("ent_remove_all helicopter_chunk");
		ServerCommand("ent_remove_all helicopter_chunk");
		
		PrintToServer("ent_remove_all gib");
		ServerCommand("ent_remove_all gib");
	}
}


public Action:fTimer_FloodFiller(Handle:timer)
{
	for (new i=1; i<=MaxClients; i++)
	{
		g_last_impulse[i] = (g_last_impulse[i] < 10) ? g_last_impulse[i] + 1 : 10;
		g_next_entfire[i] = (g_next_entfire[i] < 10) ? g_next_entfire[i] + 1 : 10;
		g_next_vehicle[i] = (g_next_vehicle[i] < 1) ? g_next_vehicle[i] + 1 : 1;
		g_next_remove[i] = (g_next_remove[i] > 10) ? g_next_remove[i] + 1 : 10;
		
		g_totalcommands[i] = 0;
		// PrintToServer("CL %i - %i", i, g_next_vehicle[i]);
	}
}


public Action:ev_disconnect_cleargravitypellets(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new iClient = GetClientOfUserId(iUserId);
	
	for (new gravityPellet=1; gravityPellet<=GetEntityCount(); gravityPellet++)
	{
		if (IsValidEntity(gravityPellet) && IsEntNetworkable(gravityPellet)) {
			
			decl String:class1[256];
			GetEntityClassname(gravityPellet, class1, 256);
			
			if (StrEqual(class1, "gravity_pellet", false))
			{
				new weapon = GetEntPropEnt(gravityPellet, Prop_Send, "m_hOwnerEntity");
				
				if (IsValidEntity(weapon) && IsEntNetworkable(weapon))
				{
					new owner = GetEntPropEnt(weapon, Prop_Send, "m_hOwnerEntity");
					
					if (owner == iClient || owner == -1) {
						PrintToServer("     [JBMOD] removing pellet %i", gravityPellet);
						jb_RemoveEntity(gravityPellet);
					}
				}
			}
		}
	}
	
	return Plugin_Continue;
}


public Action:ev_disconnect_entremoved(Handle:event, const String:name[], bool:dontBroadcast)
{
	new iUserId = GetEventInt(event, "userid");
	new client = GetClientOfUserId(iUserId);
	
	g_player_useridcache[client] = 0;
	
	return Plugin_Continue;
}


public void OutputHook(const char[] name, int caller, int activator, float delay)
{
	char callerClassname[64];
	if (caller >= 0 && IsValidEntity(caller)) {
		GetEntityClassname(caller, callerClassname, sizeof(callerClassname));
	}

	char activatorClassname[64];
	if (activator >= 0 && IsValidEntity(activator)) {
		GetEntityClassname(activator, activatorClassname, sizeof(activatorClassname));
	}

	LogMessage("[ENTOUTPUT] %s (caller: %d/%s, activator: %d/%s)", name, caller, callerClassname, activator, activatorClassname);
}

