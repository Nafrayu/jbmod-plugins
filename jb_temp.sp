public Plugin:myinfo =
{
	name = "jbmod temp tests",
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

#include "jb_ecs/e_stack.sp"
#include "jb_ecs/e_add.sp"
#include "jb_ecs/e_setrot.sp"
#include "jb_ecs/e_test.sp"


#pragma semicolon 1


StringMap entity_blacklisted;

public OnPluginStart()
{
	entity_blacklisted = CreateTrie();
	
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
			SetTrieValue(entity_blacklisted, buf, bool:true, bool:true);
		} else {
			SetTrieValue(entity_blacklisted, buf, bool:false, bool:true);
		}

		// PrintToServer("%s", buf);
	}
	
	
	


}








