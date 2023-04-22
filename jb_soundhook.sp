public Plugin:myinfo =
{
	name = "jbmod - soundpause",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


bool g_soundpause[MAXPLAYERS+1];

//static variables
int LaserCache = 0;
int HaloSprite = 0;

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


#pragma semicolon 1


public OnPluginStart()
{
	RegConsoleCmd("sm_soundpause", cmd_soundpause);
	
	AddNormalSoundHook(OnNormalSound);
	AddAmbientSoundHook(OnAmbientSound);
}


public Action cmd_soundpause(int client, int args)
{
	g_soundpause[client] = !g_soundpause[client];
	
	if (g_soundpause[client])
	{
		PrintToChat(client, "\x01Sounds are now \x0700FF00enabled!");
	} else {
		PrintToChat(client, "\x01Sounds are now \x07FF0000disabled!");
	}

	return Plugin_Handled;
}


public Action:OnNormalSound(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	// PrintToConsoleAll("\t[JBMod] SOUND HOOKED(normal): %i %s", entity, sample);
	return Plugin_Continue;
}


// [JBMod] SOUND HOOKED(ambient): vol 1.000000 lvl 0 pit 45 flg 11
// [JBMod] I am SCREAMING<85><[U:1:213483238]><> ent_create ambient_generic targetname song health 10 message hl1\fvox\flatline.wav pitch 45

public Action:OnAmbientSound(char sample[PLATFORM_MAX_PATH], int &entity, float &volume, int &level, int &pitch, float pos[3], int &flags, float &delay)
{
	// PrintToConsoleAll("\t[JBMod] SOUND HOOKED(ambient): vol %f lvl %i pit %i flg %i", volume, level, pitch, flags);
	if (StrContains(sample, "go_alert", bool:false) != -1)
	{
		volume = 0.0;
		return Plugin_Changed;
	}
		
	if (volume > 0.1)
	{
		volume = 0.1;
		// PrintToConsoleAll("\t[JBMod] SOUND MODIFIED!");
		return Plugin_Changed;
	}
	
	return Plugin_Continue;
}
















