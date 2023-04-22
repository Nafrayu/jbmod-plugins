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
#include "jb_includes/3x4_matrix.sp"
#include "jb_includes/4x4_matrix.sp"
#include "jb_includes/toScreen.sp"
#include "jb_includes/Quaternions.sp"
#include "jb_includes/SendMsg_HudMsg.inc"
#include "jb_includes/SendKeyHintText.inc"
#include "jb_includes/SendMsg_HudMsg.inc"
#include "jb_includes/propprotection.inc"
#include "jb_ecs/e_stack.sp"
#include "jb_ecs/e_add.sp"
#include "jb_ecs/e_setrot.sp"
#include "jb_ecs/e_test.sp"
#include "jb_ecs/e_translate.sp"

#pragma semicolon 1


new Handle:hTimer_ecs;


public OnPluginStart()
{
	RegAdminCmd("e_add", cmd_e_add, ADMFLAG_GENERIC, "e_add");
	RegAdminCmd("e_stack", cmd_e_stack, ADMFLAG_GENERIC, "e_stack");
	RegAdminCmd("e_setrot", cmd_e_setrot, ADMFLAG_GENERIC, "e_setrot");
	RegAdminCmd("e_test", cmd_e_test, ADMFLAG_GENERIC, "e_test");
	RegAdminCmd("e_translate", cmd_e_translate, ADMFLAG_GENERIC, "e_translate");
	// hTimer_ecs = CreateTimer(0.0, ecs_timer_test, _, TIMER_REPEAT);
}


public OnPluginEnd()
{
	KillTimer(hTimer_ecs);
	// setpos 2177.906250 -7560.875000 368.031250;setang 89.000000 94.930923 0.000000

}


public OnClientPutInServer(client)
{
	
}


public OnEventShutdown()
{

}



public OnMapStart()
{

}


public OnEntityCreated(entity, const String:classname[])
{

}


public OnEntityDestroyed(ent)
{

}

// float rota = 0.0;

// public OnGameFrame()
// {

	// new ent1 = Entity_FindByName("myshit1");
	// new ent2 = Entity_FindByName("myshit2");
	// new ent3 = Entity_FindByName("myshit3");
	
	// if (ent1 != INVALID_ENT_REFERENCE
	// && ent2 != INVALID_ENT_REFERENCE)
	// {
		// new Float:mypos[3] = {0.0,0.0,0.0};
		// new Float:myang[3] = {0.0,0.0,0.0};
		
		// Entity_GetAbsOrigin(ent1, mypos);
		// Entity_GetAbsAngles(ent1, myang);		
		
		// new Float:worldp[3] = {0.0,0.0,0.0};
		// new Float:worlda[3] = {0.0,0.0,0.0};
		
		// rota = rota + 2.0;
		// if (rota > 360.0) {rota = 0.0;}
		
		// new Float:rot[3] = {0.0,0.0,0.0};
		// rot[1] = rota;
		// LTOW(Float:{80.0,80.0,80.0}, rot, mypos, myang, worldp, worlda);		
				
		// new Float:localp[3] = {0.0,0.0,0.0};
		// new Float:locala[3] = {0.0,0.0,0.0};		
		// WTOL(worldp, worlda, mypos, myang, localp, locala);

		// new Float:endpos[3] = {0.0,0.0,0.0};
		// new Float:endang[3] = {0.0,0.0,0.0};			
		// LTOW(localp, locala, mypos, myang, endpos, endang);
		
		
		// TeleportEntity(ent2, endpos, endang, NULL_VECTOR );		
	// }
	
	// if (ent3 != INVALID_ENT_REFERENCE)
	// {
		
		// new Float:mypos[3];
		// new Float:myang[3];
		// Entity_GetAbsOrigin(ent3, mypos);
		// Entity_GetAbsAngles(ent3, myang);		
		
		// new Float:newa[3];		
		// new Float:axis[3] = {45.0,0.0,0.0};
		// new Float:rotation[3] = {0.0,5.0,0.0};
		
		// RotateAroundAxis(myang, axis, rotation, newa);
		
		// TeleportEntity(ent3, NULL_VECTOR, newa, NULL_VECTOR);		
	// }
	
	// for (new i=1; i<=MaxClients; i++)
	// {
		// if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i))
		// {
			// float plypos3[3];
			// float plyang[3];
			// float traceend[3] = {2178.937500, -7559.093750, 368.031250};

			// float screen[2];
			// screen[0] = 0.5;
			// screen[1] = 0.5;
			
			// GetClientEyePosition(i, plypos3);
			// GetClientEyeAngles(i, plyang); //broken
			
			// bool visible = computePixelCoordinates( plypos3, plyang, traceend, screen);
			
			// if (visible)
			// {
				// stock SendMsg_HudMsg(client, channel, 
				// Float:x, Float:y, 
				// aRclr, aGclr, aBclr, aTclr, 
				// bRclr, bGclr, bBclr, bTclr, 
				// effect, 
				// Float:fadein, Float:fadeout, 
				// Float:holdtime, Float:fxtime, 
				// const String:szMsg[]
				// const String:format[], any:...)
				// SendMsg_HudMsg(i, 2, screen[0], screen[1], 255, 255, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 0.2, 0.0, "Gullible!");
			// }
		// }
	// }
// }

