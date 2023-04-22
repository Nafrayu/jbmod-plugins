// This example will make ent1 face up from ent2.
// ent1:SetAngles(ent1:AlignAngles(ent1:GetForward():Angle(), ent2:GetUp():Angle()))
// Output: Sets ent1's angle to one where ent1 faces up from ent2.

// local Ang1, Ang2 = Norm1:Angle(), ( -Norm2 ):Angle()
// local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )
// Phys1:SetAngles( TargetAngle )

// LTOW = ADD
// WTOL = SUB						

// ROTATE BASED ON WORLD ANGLES
// LTOW(NULL_VECTOR, toRotate, NULL_VECTOR, Float:{5.0,0.0,0.0}, NULL_VECTOR, newa);

// ROTATE BASED ON LOCAL ANGLES
// LTOW(NULL_VECTOR, Float:{5.0,0.0,0.0}, NULL_VECTOR, toRotate, NULL_VECTOR, newa);


public Plugin:myinfo =
{
	name = "jbmod toolgun",
	author = "Nafrayu",
	description = "Big thank you to Relt#4423 for the math lessons! :)",
	version = "1.0",
	url = "nafrayu.com"
};


//static stuff
int g_iPhysicsGunVM;
// int g_iPhysicsGunWorld;
new LaserCache = 0;
// new HaloSprite = 0;


#define TOOL_MODE_ROPE 0
#define TOOL_MODE_ELASTIC 1
#define TOOL_MODE_WELD 2
#define TOOL_MODE_BALLSOCKET 3
#define TOOL_MODE_PULLEY 4
#define TOOL_MODE_EASY_WELD 5
#define TOOL_MODE_EASY_BALL_SOCKET 6
#define TOOL_MODE_AXIS 7
#define TOOL_MODE_SLIDER 8
#define TOOL_MODE_NAILGUN 9
#define TOOL_MODE_FACEPUSER 10
#define TOOL_MODE_EYEPOSER 11
#define TOOL_MODE_REMOVER 12
#define TOOL_MODE_IGNITE 13
#define TOOL_MODE_PAINT 14
#define TOOL_MODE_DUPLICATE 15
#define TOOL_MODE_COLOR 16
#define TOOL_MODE_MAGNETISE 17
#define TOOL_MODE_NO_COLLIDE 18
#define TOOL_MODE_DYNAMITE 19
#define TOOL_MODE_MATERIAL 20
#define TOOL_MODE_RENDER_TARGET_CAMERA 21
#define TOOL_MODE_UNKNOWN1 22
#define TOOL_MODE_THRUSTERS 23
#define TOOL_MODE_PHYSPROPS 24
#define TOOL_MODE_STATUE 25
#define TOOL_MODE_BALLOONS 26
#define TOOL_MODE_EMITTERS 27
#define TOOL_MODE_SPRITES 28
#define TOOL_MODE_WHEELS 29
#define TOOL_MODE_UNKNOWN2 30
#define TOOL_MODE_UNKNOWN3 31
#define TOOL_MODE_UNKNOWN4 32
#define TOOL_MODE_UNKNOWN5 33


// from gmod9
char toolgunmode_names[][] = {
 "Rope", "Elastic", "Weld", "Ballsocket", "Pulley", "Easy Weld",
 "Easy Ball Socket", "Axis", "Slider", "Nailgun", "Facepuser",
 "Eyeposer", "Remover", "Ignite", "Paint", "Duplicate", "Color",
 "Magnetise", "No Collide", "Dynamite", "Material",
 "Render Target Camera", "", "Thrusters", "Physprops", "Statue",
 "Balloons", "Emitters", "Sprites", "Wheels", "", "", "", ""
};


//temp gameplay stuff
bool toolgun_enabled[MAXPLAYERS+1]; // use this to check if weapon_bugbait is currently in "SWEP mode"

int toolg_mode[MAXPLAYERS+1];
int toolg_entref[MAXPLAYERS+1][2];

float toolg_normals[MAXPLAYERS+1][2][3];
float toolg_oldpos[MAXPLAYERS+1][3];
float toolg_nextshot[MAXPLAYERS+1];

int g_iThrusterNumberSetting[MAXPLAYERS +1]; // stores the wanted thruster number for each player
int g_iThrusterNumber[2048]; // stores the actual thruster number per entity
// TODO: steamid ownership...
new Handle:g_hArray_ThrusterOwner[MAXPLAYERS + 1] = { INVALID_HANDLE, ... }; //stores ownership



// static stuff
#define MODEL_PHYSICSGUN	"models/weapons/w_physics.mdl"
// #define MODEL_PHYSICSGUNVM	"models/weapons/v_superphyscannon.mdl"
#define MODEL_PHYSICSGUNVM	"models/weapons/v_stunbaton.mdl"
#define MODEL_PHYSICSLASER	"materials/sprites/physbeam.vmt"
#define MODEL_HALOINDEX		"materials/sprites/halo01.vmt"
#define MODEL_BLUEGLOW		"materials/sprites/blueglow2.vmt"
#define SOUND_PICKUP		"weapons/physcannon/physcannon_pickup.wav"
#define SOUND_DROP			"weapons/physcannon/physcannon_drop.wav"


// toolg_mode[0]= = Rope                      |done
// toolg_mode[1]= = Elastic                   |
// toolg_mode[2]= = Weld                      |done
// toolg_mode[3]= = Ballsocket                |
// toolg_mode[4]= = Pulley                    |
// toolg_mode[5]= = Easy Weld                 |
// toolg_mode[6]= = Easy Ball Socket          |
// toolg_mode[7]= = Axis                      |done
// toolg_mode[8]= = Slider                    |
// toolg_mode[9]= = Nailgun                   |
// toolg_mode[10] = Facepuser                 |
// toolg_mode[11] = Eyeposer                  |
// toolg_mode[12] = Remover                   |done
// toolg_mode[13] = Ignite                    |
// toolg_mode[14] = Paint                     |
// toolg_mode[15] = Duplicate                 |
// toolg_mode[16] = Color                     |
// toolg_mode[17] = Magnetise                 |
// toolg_mode[18] = No Collide                |
// toolg_mode[19] = Dynamite                  |
// toolg_mode[20] = Material                  |
// toolg_mode[21] = Render Target Camera      |
// toolg_mode[22] =                           |
// toolg_mode[23] = Thrusters                 |
// toolg_mode[24] = Physprops                 |
// toolg_mode[25] = Statue                    |
// toolg_mode[26] = Balloons                  |
// toolg_mode[27] = Emitters                  |
// toolg_mode[28] = Sprites                   |
// toolg_mode[29] = Wheels                    |
// toolg_mode[30] =                           |
// toolg_mode[31] =                           |
// toolg_mode[32] =                           |
// toolg_mode[33] =                           |


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
#include "jb_toolgun/cmd.sp"
#include "jb_toolgun/thrusters.sp"


#pragma semicolon 1


public OnMapStart()
{
	g_iPhysicsGunVM = PrecacheModel(MODEL_PHYSICSGUNVM);
	// g_iPhysicsGunWorld = PrecacheModel(MODEL_PHYSICSGUN);
	LaserCache = PrecacheModel("sprites/laserbeam.spr");
	// HaloSprite = PrecacheModel("materials/sprites/halo.vmt");
}


public OnEventShutdown()
{
	UnhookEvent("player_spawn", ev_player_spawn_giveitems);
	UnhookEvent("player_activate", ev_player_activate_fixstuff);
}


public OnPluginEnd()
{
	// KillTimer(drawscoresTimer);
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i))
		{
			SDKUnhook(i, SDKHook_WeaponSwitch, WeaponSwitchHook);
		}
	}
}


public OnPluginStart()
{
	HookEntityOutput("physics_cannister", "OnAwakened", OutputHook);
	HookEvent("player_spawn", ev_player_spawn_giveitems, EventHookMode_Post);
	HookEvent("player_activate", ev_player_activate_fixstuff, EventHookMode_Post);

	AddCommandListener(cmd_physgun_switch, "physgun_switch");

	// drawscoresTimer = CreateTimer(0.25, drawScoresFunc, _, TIMER_REPEAT);

	RegConsoleCmd("jb_toolmode", cmd_jb_toolmode);
	
	RegConsoleCmd("+jb_thrust", cmd_jb_thrustOn);
	RegConsoleCmd("-jb_thrust", cmd_jb_thrustOff);
	
	RegConsoleCmd("jb_thrust_num", cmd_jb_thrust_num);
		
	
	for (new i=1; i<=MaxClients; i++)
	{
		toolgun_dat_reset(i);
		g_hArray_ThrusterOwner[i] = CreateArray();
		
		if (IsClientInGame(i))
		{
			SDKHook(i, SDKHook_WeaponSwitch, WeaponSwitchHook);
		}
	}	
}


public OnClientPutInServer(client) 
{
	toolgun_dat_reset(client);
	
	if(IsClientInGame(client))
	{
		SDKHook(client, SDKHook_WeaponSwitch, WeaponSwitchHook);
	}
}

void toolgun_dat_reset(client)
{
	toolg_mode[client] = 0;
	toolg_entref[client][0] = INVALID_ENT_REFERENCE;
	toolg_entref[client][1] = INVALID_ENT_REFERENCE;		
	toolg_normals[client][0][0] = 0.0;
	toolg_normals[client][0][1] = 0.0;
	toolg_normals[client][0][2] = 0.0;		
	toolg_normals[client][1][0] = 0.0;
	toolg_normals[client][1][1] = 0.0;
	toolg_normals[client][1][2] = 0.0;
	toolg_nextshot[client] = 0.0;
}


public Action:WeaponSwitchHook(client, wep)
{
	decl String:class[64]; 
	GetEntityClassname(wep, class, sizeof(class));
	
	// PrintToConsole(client, "you switched to %i %s", wep, class);
	
	
	// this shit doesnt work when using
	// SetEntPropEnt(client, Prop_Data, "m_hActiveWeapon", weapon);
	
	// if(StrEqual(class, "weapon_bugbait") == true && toolgun_enabled[client] == true)
	// {
		// PrintToConsole(client, "entering toolgun mode! %i %s", wep, class);
		
		// SendMsg_HudMsg(client, 1, -1.0, 0.55, 255, 0, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 999999.0, 0.0, "Toolgun: %s", toolg_mode_names[toolg_mode[client]]);		
	// }

	
	if(StrEqual(class, "weapon_bugbait") == false && toolgun_enabled[client] == true)
	{
		PrintToConsole(client, "no longer in toolgun mode! %i %s", wep, class);
		toolgun_enabled[client] = false;
		
		//get rid of the hud message (scuffed (tm))
		SendMsg_HudMsg(client, 1, -1.0, 0.55, 255, 0, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 0.1, 0.0, " ");
		
		// RemovePlayerItem(client, wep);
		// RemoveEdict(wep);
		// new newWeapon = GivePlayerItem(client, "weapon_m84");
		// new PrimaryAmmoType = GetEntProp(newWeapon, Prop_Data, "m_iPrimaryAmmoType");
		// SetEntProp(client, Prop_Send, "m_iAmmo", 1, _, PrimaryAmmoType);
		// InstantSwitch(client, newWeapon);
	}
	
	return Plugin_Continue;
}



// weld = phys_constraint, parented to first
	// disappears correctly
	
// rope = phys_lengthconstraint
	// 1 keyframe_rope between 2 parented prop_physics (the prop_physics are attached to the props using phys_constraint)
		// remove 1st: phys_constraint and prop_physics remains on 1st
		// remove 2nd: phys_constraint and prop_physics remains on 1st
		// undo: cleans up properly
		
// elastic phys_spring
	// behaves like rope
	
// ballsocket phys_ballsocket
	// behaves like weld

//pulley phys_pulleyconstraint
	// fuck this im not gonna document all of this
		// undo: cleans up properly

// axis phys_hinge
	// behaves like weld

// slider phys_slideconstraint
	// 2 env_sprite, 1 on each click pos
		// leaves both sprites behind
		// undo: cleans up properly

// wheel phys_hinge
	// correct


// void OnEntityDestroyed(int entity)
// new Float:plypos3[3];
// new Float:myangaaaaa[3];
// new Float:traceend[3] = {0.0, 0.0, 0.0};
// GetClientEyePosition(client, plypos3);
// GetClientEyeAngles(client, myangaaaaa);
// PrintToConsole(client, "bbbb %f %f %f", myangaaaaa[0], myangaaaaa[1], myangaaaaa[2]);
// decl Float:fwd[ 3 ];
// GetAngleVectors(myangaaaaa,fwd,NULL_VECTOR,NULL_VECTOR);
// ScaleVector(fwd, 4096.0);
// AddVectors(plypos3, fwd, traceend);
// TR_TraceRayFilter(plypos3, traceend, MASK_ALL, RayType_EndPoint, TraceRayDontHitSelf, client);
// TE_SetupBeamPoints(plypos3, traceend, LaserCache, 0, 0, 0, 0.1,
// 4.0, 4.0, 0, 0.0, {255,0,255,255}, 0);
// TE_SendToAll(0.0);


public Action:OnPlayerRunCmd(
client, &buttons, &impulse, Float:vel[3], Float:angles[3],
&weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{

	
	if (buttons & IN_ATTACK || buttons & IN_ATTACK2 || buttons & IN_RELOAD)
	{
		new String:wep[256];
		Client_GetActiveWeaponName(client, wep, 256);

		if (StrEqual(wep, "weapon_bugbait") && toolgun_enabled[client])
		{
			new Float:plypos[3];
			new Float:endpos[3] = {0.0, 0.0, 0.0};
			new Float:normal[3] = {0.0, 0.0, 0.0};
			GetClientAbsOrigin(client, plypos);
			new ent = TracePlayerAnglesNormal(client, angles, 4096.0, endpos, normal);
			
			float normalasang[3];
			// ScaleVector(normal, 16.0);
			// PrintToConsole(client, "endpos w %f %f %f", endpos[0], endpos[1], endpos[2]);
			
			// AddVectors(endpos, normal, normal);		
			GetVectorAngles(normal, normalasang);
			// PrintToConsole(client, "normal  w %f %f %f", normalasang[0], normalasang[1], normalasang[2]);
			
			
			// TE_SetupBeamPoints(endpos, normal, LaserCache, 0, 0, 0, 0.1, 4.0, 4.0, 1, 0.0, {255,0,255,255}, 0);
			// TE_SendToAll(0.0);
			

			
			if (ent != 0 && toolg_nextshot[client] < GetGameTime() && buttons & IN_ATTACK)
			{
			
				toolg_nextshot[client] = GetGameTime() + 0.3;
				
				new oldent = EntRefToEntIndex(toolg_entref[client][0]);
				
				
				
				// █████████████████████████████████████████████████████████████████████
				//          FLYING
					
				if (toolg_mode[client] == 998)
				{
					decl Float:fwd[ 3 ];
					GetAngleVectors(angles,fwd,NULL_VECTOR,NULL_VECTOR);
					ScaleVector(fwd, 3000.0);
					TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fwd);
				}
				
				
				
				else if (toolg_mode[client] == TOOL_MODE_REMOVER)
				{
					// █████████████████████████████████████████████████████████████████████
					//          REMOVER

					if (   (ent > 0 )
					&& (
					Entity_ClassNameMatches(ent, "prop_physics", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
					|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
					|| Entity_ClassNameMatches(ent, "npc_", bool:true)
					|| Entity_ClassNameMatches(ent, "item_", bool:true)
					|| Entity_ClassNameMatches(ent, "weapon_", bool:true)
					// || Entity_ClassNameMatches(ent, "prop_", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_ragdoll", bool:true)
					)
					)
					{
						jb_toolgun_effect(client, ent, plypos, endpos);
						// jb_RemoveEntity(ent);
						// AcceptEntityInput(ent, "kill");
					}
					else if (ent > 0)
					{
						new String:cname[256];
						Entity_GetClassName(ent,cname,256);
						PrintToConsole(client, "%i %s", ent, cname);
					}

				}
				
				
				
				
				
				
				
				
				
				
				// else if (toolg_mode[client] == 999)
				// {
					// █████████████████████████████████████████████████████████████████████
					//          flaregun

					// AddVectors(plypos, Float:{0.0,0.0,64.0}, plypos);

					// new flareprop = CreateEntityByName("prop_physics_multiplayer");
					// DispatchKeyValue(flareprop, "model", "models/weapons/w_bugbait.mdl");
					// TeleportEntity(flareprop, plypos, angles, NULL_VECTOR );
					// Entity_SetOwner(flareprop, client);
					// DispatchSpawn(flareprop);

					// new flare = CreateEntityByName("env_flare");
					// TeleportEntity(flare, plypos, angles, NULL_VECTOR );
					// DispatchSpawn(flare);

					// Entity_SetParent(flare, flareprop);

					// new Float:fwd[3] = {0.0,0.0,0.0};
					// GetAngleVectors(angles, fwd, NULL_VECTOR, NULL_VECTOR);
					// ScaleVector(fwd, 5000.0);

					// Phys_ApplyForceCenter(flareprop, fwd);

					// EmitGameSoundToAll("Weapon_FlareGun.Single", client);

					// Entity_ChangeOverTime(flareprop, 1.0, killme);

				// }
				
				
				
				
				
				
				
				
				else if (toolg_mode[client] == TOOL_MODE_WELD)
				{
					// █████████████████████████████████████████████████████████████████████
					//          weld
					
					if (   (ent > 0 )
					&& (
					Entity_ClassNameMatches(ent, "prop_physics", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
					|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
					|| Entity_ClassNameMatches(ent, "physics_cannister", bool:true)
					)
					)
					{
						if (oldent == INVALID_ENT_REFERENCE)
						{
							jb_toolgun_effect(client, ent, plypos, endpos);
							toolg_entref[client][0] = EntIndexToEntRef(ent);
							
							// PrintToChat(client, "-------first ent! %i", ent);
						}
						else if (oldent != ent && IsValidEntity(oldent) && IsValidEntity(ent))
						{
							jb_toolgun_effect(client, ent, plypos, endpos);
							toolg_entref[client][0] = INVALID_ENT_REFERENCE;
							
							//get info
							float propPosOld[3]; GetEntPropVector(oldent, Prop_Send, "m_vecOrigin", propPosOld);
							float propAngOld[3]; GetEntPropVector(oldent, Prop_Send, "m_angRotation", propAngOld);
							
							//math shit
							new Float:oldWorldPos[3];
							LTOW(toolg_oldpos[client], NULL_VECTOR, propPosOld, propAngOld, oldWorldPos, NULL_VECTOR);
							
							//ent name shit
							new String:firstname_Old[256];
							Entity_GetName(oldent, firstname_Old, 256);							
							new String:secondname_Old[256];
							Entity_GetName(ent, secondname_Old, 256);							
							new String:firstname_Temp[256];
							Format(firstname_Temp, 256, "myweld_first_%i_%i", client, oldent);							
							new String:secondname_Temp[256];
							Format(secondname_Temp, 256, "myweld_second_%i_%i", client, ent);
							Entity_SetName(oldent, firstname_Temp);
							Entity_SetName(ent, secondname_Temp);
							
							// constraint
							new constraint = CreateEntityByName("phys_constraint");
							DispatchKeyValue(constraint, "attach1", firstname_Temp);
							DispatchKeyValue(constraint, "attach2", secondname_Temp);
							// DispatchKeyValue(constraint, "teleportfollowdistance", "1");
							DispatchKeyValue(constraint, "spawnflags", "1");
							TeleportEntity(constraint, oldWorldPos, NULL_VECTOR, NULL_VECTOR);
							DispatchSpawn(constraint);
							ActivateEntity(constraint);
							Entity_SetParent(constraint, oldent);

							
							// reset names
							Entity_SetName(oldent, firstname_Old);
							Entity_SetName(ent, secondname_Old);
							
							// PrintToChat(client, "weld! %i %i", oldent, ent);

							// if (HasPhysics(oldent) && HasPhysics(ent))
							// {
								// PrintToChat(client, "weld fin!");
								// Phys_CreateFixedConstraint(oldent, ent, INVALID_HANDLE);
							// }
						}		
					}
				}
				
				
				
				
				
				
				
				
				
				
				
				else if (toolg_mode[client] == TOOL_MODE_ROPE)
				{
					// █████████████████████████████████████████████████████████████████████
					//          ROPE
					
					if (   (ent > 0 )
					&& (
					Entity_ClassNameMatches(ent, "prop_physics", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
					|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
					|| Entity_ClassNameMatches(ent, "physics_cannister", bool:true)
					)
					)
					{
						if (oldent == INVALID_ENT_REFERENCE)
						{
							//get info
							float propPos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", propPos);
							float propAng[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", propAng);
							
							
							jb_toolgun_effect(client, ent, plypos, endpos);
							
							//store local offset for later
							WTOL(endpos, NULL_VECTOR, propPos, propAng, toolg_oldpos[client], NULL_VECTOR);
							
							//store 1st entity for the rope
							toolg_entref[client][0] = EntIndexToEntRef(ent);
						}
						else if (oldent != ent && IsValidEntity(oldent) && IsValidEntity(ent))
						{
							//get info
							float propPos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", propPos);
							float propAng[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", propAng);
							
							float propPosOld[3]; GetEntPropVector(oldent, Prop_Send, "m_vecOrigin", propPosOld);
							float propAngOld[3]; GetEntPropVector(oldent, Prop_Send, "m_angRotation", propAngOld);
							
							jb_toolgun_effect(client, ent, plypos, endpos);
							
							//invalidate 1st entity
							toolg_entref[client][0] = INVALID_ENT_REFERENCE;
							
							//math shit
							new Float:hitPosLocal[3];
							WTOL(endpos, NULL_VECTOR, propPos, propAng, hitPosLocal, NULL_VECTOR);
							new Float:oldWorldPos[3];
							LTOW(toolg_oldpos[client], NULL_VECTOR, propPosOld, propAngOld, oldWorldPos, NULL_VECTOR);
							
							
							
							
							
							// new Float:distVec[3];
							// MakeVectorFromPoints(endpos, oldWorldPos, distVec);	
							// new String:dist[256];
							// FloatToString(GetVectorLength(distVec), dist, 256);
							
							//ent name shit
							new String:firstname_Old[256];
							Entity_GetName(oldent, firstname_Old, 256);							
							new String:secondname_Old[256];
							Entity_GetName(ent, secondname_Old, 256);							
							new String:firstname_Temp[256];
							Format(firstname_Temp, 256, "myweld_first_%i_%i", client, oldent);							
							new String:secondname_Temp[256];
							Format(secondname_Temp, 256, "myweld_second_%i_%i", client, ent);
							Entity_SetName(oldent, firstname_Temp);
							Entity_SetName(ent, secondname_Temp);
							
							// constraint
							new constraint = CreateEntityByName("phys_lengthconstraint");
							DispatchKeyValue(constraint, "attach1", firstname_Temp);
							DispatchKeyValue(constraint, "attach2", secondname_Temp);
							DispatchKeyValueVector(constraint, "origin", oldWorldPos);
							DispatchKeyValueVector(constraint, "attachpoint", endpos);
							//DispatchKeyValue(constraint, "addlength", dist);
							DispatchKeyValue(constraint, "addlength", "0.0");
							DispatchKeyValue(constraint, "forcelimit", "0");
							DispatchKeyValue(constraint, "torquelimit", "0");
							// DispatchKeyValue(constraint, "teleportfollowdistance", "1");
							DispatchKeyValue(constraint, "spawnflags", "1");
							TeleportEntity(constraint, oldWorldPos, NULL_VECTOR, NULL_VECTOR);
							DispatchSpawn(constraint);
							ActivateEntity(constraint);
							Entity_SetParent(constraint, oldent);
							
							new myropetarget = CreateEntityByName("keyframe_rope");
							DispatchSpawn(myropetarget);
							Entity_SetParent(myropetarget, ent);
							TeleportEntity(myropetarget, hitPosLocal, NULL_VECTOR, NULL_VECTOR);
							
							new visrope = CreateEntityByName("move_rope");
							DispatchKeyValue(visrope, "RopeMaterial", "cable/rope.vmt");
							SetEntPropEnt(visrope, Prop_Send, "m_hStartPoint", visrope);
							SetEntPropEnt(visrope, Prop_Send, "m_hEndPoint", myropetarget);
							DispatchSpawn(visrope);	
							Entity_SetParent(visrope, oldent);
							TeleportEntity(visrope, toolg_oldpos[client], NULL_VECTOR, NULL_VECTOR);

							// reset names
							Entity_SetName(oldent, firstname_Old);
							Entity_SetName(ent, secondname_Old);
						}
					}
				}
				
				
				
				

				else if (toolg_mode[client] == TOOL_MODE_AXIS)
				{
					// █████████████████████████████████████████████████████████████████████
					//          AXIS
					
					if (   (ent > 0 )
					&& (
					Entity_ClassNameMatches(ent, "prop_physics", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
					|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
					|| Entity_ClassNameMatches(ent, "physics_cannister", bool:true)
					)
					)
					{
						if (oldent == INVALID_ENT_REFERENCE)
						{
							//get info
							float propPos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", propPos);
							float propAng[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", propAng);
							
							
							jb_toolgun_effect(client, ent, plypos, endpos);
							
							//store local offset for later
							WTOL(endpos, NULL_VECTOR, propPos, propAng, toolg_oldpos[client], NULL_VECTOR);
							
							//store 1st entity for the rope
							toolg_entref[client][0] = EntIndexToEntRef(ent);
							CopyVector(normal, toolg_normals[client][0]);
						}
						else if (oldent != ent && IsValidEntity(oldent) && IsValidEntity(ent))
						{
							//get info
							float propPos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", propPos);
							float propAng[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", propAng);
							
							float propPosOld[3]; GetEntPropVector(oldent, Prop_Send, "m_vecOrigin", propPosOld);
							float propAngOld[3]; GetEntPropVector(oldent, Prop_Send, "m_angRotation", propAngOld);
							
							jb_toolgun_effect(client, ent, plypos, endpos);
							
							//invalidate 1st entity
							toolg_entref[client][0] = INVALID_ENT_REFERENCE;
							
							//math shit
							new Float:hitPosLocal[3];
							WTOL(endpos, NULL_VECTOR, propPos, propAng, hitPosLocal, NULL_VECTOR);
							
							// old normal as angle
							float NormalOldAng[3];
							ScaleVector(toolg_normals[client][0], -1.0);
							GetVectorAngles(toolg_normals[client][0], NormalOldAng);
		
							// new normal as angle
							float NormalNewAng[3];
							GetVectorAngles(normal, NormalNewAng);

							// find difference in local space of old normal
							float myDiff[3];							
							WTOL(NULL_VECTOR, NormalNewAng, NULL_VECTOR, NormalOldAng, NULL_VECTOR, myDiff);
							
							// rotate prop around the axis of the old normal
							float finalAng[3];
							RotateAroundAxis(propAngOld, NormalOldAng, myDiff, finalAng);
							
							// position shit
							new Float:newpos[3];
							
							// don't fully understand why i have to invert the old local hitpos yet..
							// but it works
							toolg_oldpos[client][0] = -toolg_oldpos[client][0];
							toolg_oldpos[client][1] = -toolg_oldpos[client][1];
							toolg_oldpos[client][2] = -toolg_oldpos[client][2];
							
							LTOW(toolg_oldpos[client], NULL_VECTOR, endpos, finalAng, newpos, NULL_VECTOR);

							// apply
							TeleportEntity(oldent, newpos, finalAng, NULL_VECTOR);
							

							
							
							float hingeaxis[3];
							AddVectors(endpos, normal, hingeaxis);
							
							
							
							//ent name shit
							new String:firstname_Old[256];
							Entity_GetName(oldent, firstname_Old, 256);							
							new String:secondname_Old[256];
							Entity_GetName(ent, secondname_Old, 256);							
							new String:firstname_Temp[256];
							Format(firstname_Temp, 256, "myweld_first_%i_%i", client, oldent);							
							new String:secondname_Temp[256];
							Format(secondname_Temp, 256, "myweld_second_%i_%i", client, ent);
							Entity_SetName(oldent, firstname_Temp);
							Entity_SetName(ent, secondname_Temp);
							
							// constraint
							new constraint = CreateEntityByName("phys_hinge");
							DispatchKeyValue(constraint, "attach1", firstname_Temp);
							DispatchKeyValue(constraint, "attach2", secondname_Temp);
							DispatchKeyValueVector(constraint, "origin", endpos);
							DispatchKeyValueVector(constraint, "hingeaxis", hingeaxis);
							// DispatchKeyValue(constraint, "addlength", dist);
							// DispatchKeyValue(constraint, "addlength", "0.0");
							DispatchKeyValue(constraint, "forcelimit", "0");
							DispatchKeyValue(constraint, "torquelimit", "0");
							// DispatchKeyValue(constraint, "teleportfollowdistance", "1");
							DispatchKeyValue(constraint, "spawnflags", "1");
							TeleportEntity(constraint, endpos, NULL_VECTOR, NULL_VECTOR);
							DispatchSpawn(constraint);
							ActivateEntity(constraint);
							Entity_SetParent(constraint, oldent);
						
							// reset names
							Entity_SetName(oldent, firstname_Old);
							Entity_SetName(ent, secondname_Old);							
						}
					}
				}
				
				
								

	
				else if (toolg_mode[client] == TOOL_MODE_THRUSTERS)
				{
					// █████████████████████████████████████████████████████████████████████
					//          THRUSTER
					
					if (   (ent > 0 )
					&& (
					Entity_ClassNameMatches(ent, "prop_physics", bool:true)
					|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
					|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
					|| Entity_ClassNameMatches(ent, "physics_cannister", bool:true)
					)
					)
					{
						if (oldent == INVALID_ENT_REFERENCE)
						{
							//get info
							float propPos[3]; GetEntPropVector(ent, Prop_Send, "m_vecOrigin", propPos);
							float propAng[3]; GetEntPropVector(ent, Prop_Send, "m_angRotation", propAng);
							
							jb_toolgun_effect(client, ent, plypos, endpos);
							
							// new normal as angle
							// rotate thruster so it points away from the surface
							float NormalNewAng[3];
							GetVectorAngles(normal, NormalNewAng);
							float thrustAng[3];
							LTOW(NULL_VECTOR, Float:{90.0,0.0,0.0}, NULL_VECTOR, NormalNewAng, NULL_VECTOR, thrustAng);
							
							//ent name shit
							new String:secondname_Old[256];
							Entity_GetName(ent, secondname_Old, 256);
							new String:secondname_Temp[256];
							Format(secondname_Temp, 256, "myweld_second_%i_%i", client, ent);
							Entity_SetName(ent, secondname_Temp);
							
							// thruster spawning
							new thruster = CreateEntityByName("physics_cannister");
							DispatchKeyValue(thruster, "thrust", "30000000");
							DispatchKeyValue(thruster, "fuel", "2000000000");
							DispatchKeyValue(thruster, "massoverride", "10");
							DispatchKeyValueVector(thruster, "origin", endpos);
							DispatchKeyValue(thruster, "model", "models/props_junk/MetalBucket01a.mdl");
							TeleportEntity(thruster, endpos, thrustAng, NULL_VECTOR);
							DispatchSpawn(thruster);
							ActivateEntity(thruster);
							
							SetThrusterOwner(thruster, client);
							g_iThrusterNumber[thruster] = g_iThrusterNumberSetting[client];
							
							SetEntProp(thruster, Prop_Data, "m_takedamage", 0); // dont die if we're getting shot
							
							new String:firstname_Temp[256]; // change name of thruster so we can weld
							Format(firstname_Temp, 256, "myweld_first_%i_%i", client, thruster);
							Entity_SetName(thruster, firstname_Temp);	
							Entity_SetParent(thruster, ent); // parent - this will make it so it auto-cleansup itself
							
							// constraint - weld the thruster to prop
							new constraint = CreateEntityByName("phys_constraint");
							DispatchKeyValue(constraint, "attach1", firstname_Temp);
							DispatchKeyValue(constraint, "attach2", secondname_Temp);
							DispatchKeyValue(constraint, "spawnflags", "1");
							TeleportEntity(constraint, endpos, NULL_VECTOR, NULL_VECTOR);
							DispatchSpawn(constraint);
							ActivateEntity(constraint);
							Entity_SetParent(constraint, thruster); // parent - this will make it so it auto-cleansup itself
							
							// reset name of prop (no need to reset thruster name)
							Entity_SetName(ent, secondname_Old);
						}
					}
				}
				
				
				
				
				
				
			// █████████████████████████████████████████████████████████████████████
			//          TOOL MODES END
			} //if (buttons & IN_ATTACK)
				
			
			
			
			
			

			if (toolg_nextshot[client] < GetGameTime() && buttons & IN_ATTACK2)
			{
				PrintToConsole(client, "new tool mode: %s", toolgunmode_names[toolg_mode[client]]);
				toolg_nextshot[client] = GetGameTime() + 0.3;
				
				if (toolg_mode[client] == 0)
				{
					toolg_mode[client] = 2;
				}
				else if (toolg_mode[client] == 2)
				{
					toolg_mode[client] = 23;
				}
				
				else if (toolg_mode[client] == 23)
				{
					toolg_mode[client] = 7;
				}
				
				else if (toolg_mode[client] == 7)
				{
					toolg_mode[client] = 0;
				}
				
				SendMsg_HudMsg(client, 1, -1.0, 0.55, 255, 0, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 999999.0, 0.0, "Toolgun: %s\n(Press Reload to remove items", toolgunmode_names[toolg_mode[client]]);
			}

			if (toolg_nextshot[client] < GetGameTime() && buttons & IN_RELOAD)
			{
				toolg_nextshot[client] = GetGameTime() + 0.3;
				
				// █████████████████████████████████████████████████████████████████████
				//          REMOVER

				if (   (ent > 0 )
				&& (
				Entity_ClassNameMatches(ent, "prop_physics", bool:true)
				|| Entity_ClassNameMatches(ent, "prop_vehicle_", bool:true)
				|| Entity_ClassNameMatches(ent, "func_physbox", bool:true)
				|| Entity_ClassNameMatches(ent, "npc_", bool:true)
				|| Entity_ClassNameMatches(ent, "prop_ragdoll", bool:true)
				)
				)
				{
					jb_toolgun_effect(client, ent, plypos, endpos);
					jb_RemoveEntity(ent);
				}
				else if (ent > 0)
				{

					new String:cname[256];
					Entity_GetClassName(ent,cname,256);
					PrintToConsole(client, "%i %s", ent, cname);
				}
			}
			
			if (buttons & IN_ATTACK)
			{
				buttons = buttons & ~IN_ATTACK; //remove attack2 button
			}
			if (buttons & IN_ATTACK2)
			{
				buttons = buttons & ~IN_ATTACK2; //remove attack2 button
			}
			if (buttons & IN_RELOAD)
			{
				buttons = buttons & ~IN_RELOAD; //remove IN_RELOAD button
			}
		} //if (StrEqual(wep, "weapon_bugbait") && toolgun_enabled[client])
		return Plugin_Changed;
	} //if (buttons & IN_ATTACK || buttons & IN_ATTACK2 || buttons & IN_RELOAD)
	return Plugin_Continue;
}


public Action:ev_player_spawn_giveitems(Handle:event, const String:name[], bool:dontBroadcast)
{
	// PrintToServer("--------------------------------------SPAWN");
}


public Action:ev_player_activate_fixstuff(Handle:event, const String:name[], bool:dontBroadcast)
{
	// new iUserId = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(iUserId);
	
	
}





bool IsThrusterOwner(ent, client)
{
	return (FindValueInArray(g_hArray_ThrusterOwner[client], EntIndexToEntRef(ent)) != -1);
}


void SetThrusterOwner(ent, client)
{
	PushArrayCell(g_hArray_ThrusterOwner[client], EntIndexToEntRef(ent));
}


void RemoveThrusterOwner(ent)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		int index = -1;
		while ((index = FindValueInArray(g_hArray_ThrusterOwner[i], ent)) != -1)
		{
			//remove indexes until everything is gone
			RemoveFromArray(g_hArray_ThrusterOwner[i], index);
		}
	}
}


public void OnEntityDestroyed(int ent)
{
	if (ent > MaxClients)
	{
		RemoveThrusterOwner(EntIndexToEntRef(ent));
	}
}






// public void OnEntityCreated(int entity, const char[] classname)
// {
    // if( strcmp(classname "molotov_projectile") == 0 )
    // {
        // SDKHook(entity, SDKHook_SpawnPost, SpawnPost);
    // }
// }

// void SpawnPost(int entity)
// {
    // if( !IsValidEntity(entity) ) return;
	
    // char sModel[64];
    // GetEntPropString(entity, Prop_Data, "m_ModelName", sModel, sizeof(sModel)));

    // RequestFrame(nextFrame, EntIndexToEntRef(entity));
// }

// void nextFrame(int entity)
// {
    // if( (entity = EntRefToEntIndex(entity)) != INVALID_ENT_REFERENCE )
    // {
        // float vVel[3];
        // GetEntPropVector(entity, Prop_Send, "m_vInitialVelocity", vVel);
    // }
// } 


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

	PrintToConsoleAll("[ENTOUTPUT] %s (caller: %d/%s, activator: %d/%s)", name, caller, callerClassname, activator, activatorClassname);
}


