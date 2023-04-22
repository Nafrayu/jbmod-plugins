
// toolg_mode[0]= = Rope                      
// toolg_mode[1]= = Elastic                   
// toolg_mode[2]= = Weld                      
// toolg_mode[3]= = Ballsocket                
// toolg_mode[4]= = Pulley                    
// toolg_mode[5]= = Easy Weld                 
// toolg_mode[6]= = Easy Ball Socket          
// toolg_mode[7]= = Axis                      
// toolg_mode[8]= = Slider                    
// toolg_mode[9]= = Nailgun                   
// toolg_mode[10] = Facepuser                 
// toolg_mode[11] = Eyeposer                  
// toolg_mode[12] = Remover                   
// toolg_mode[13] = Ignite                    
// toolg_mode[14] = Paint                     
// toolg_mode[15] = Duplicate                 
// toolg_mode[16] = Color                     
// toolg_mode[17] = Magnetise                 
// toolg_mode[18] = No Collide                
// toolg_mode[19] = Dynamite                  
// toolg_mode[20] = Material                  
// toolg_mode[21] = Render Target Camera      
// toolg_mode[22] =                           
// toolg_mode[23] = Thrusters                 
// toolg_mode[24] = Physprops                 
// toolg_mode[25] = Statue                    
// toolg_mode[26] = Balloons                  
// toolg_mode[27] = Emitters                  
// toolg_mode[28] = Sprites                   
// toolg_mode[29] = Wheels                    
// toolg_mode[30] =                           
// toolg_mode[31] =                           
// toolg_mode[32] =                           
// toolg_mode[33] =                           



// public Action:cmd_physgun_switch(client, const String:command[], argc)
// {
	// toolgunmode_physgun[client] = toolgunmode_physgun[client] + 1;
	// toolgunmode_weld_ref[client][0] = INVALID_ENT_REFERENCE;
	
	// if (toolgunmode_physgun[client] > 4)
	// {
		// toolgunmode_physgun[client] = 0;
	// }
		
	// SendMsg_HudMsg(client, 1, -1.0, 0.55, 255, 128, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, "Toolgun Mode: %s", toolgunmode_names_physgun[toolgunmode_physgun[client]]);
// }



// DialogType_Msg = 0,     /**< just an on screen message */
// DialogType_Menu,        /**< an options menu */
// DialogType_Text,        /**< a richtext dialog */
// DialogType_Entry,       /**< an entry box */
// DialogType_AskConnect   /**< ask the client to connect to a specified IP */

// typedef enum
// {
	// DIALOG_MSG = 0,		// just an on screen message
	// DIALOG_MENU,		// an options menu
	// DIALOG_TEXT,		// a richtext dialog
	// DIALOG_ENTRY,		// an entry box
	// DIALOG_ASKCONNECT	// Ask the client to connect to a specified IP address. Only the "time" and "title" keys are used.
// } DIALOG_TYPE;

// creates an onscreen menu with various option buttons
//	The keyvalues param can contain these fields:
//	"title" - (string) the title to show in the hud and in the title bar
//	"msg" - (string) a longer message shown in the GameUI
//  "color" - (color) the color to display the message in the hud (white by default)
//	"level" - (int) the priority of this message (closer to 0 is higher), only 1 message can be outstanding at a time
//	"time" - (int) the time in seconds this message should stay active in the GameUI (min 10 sec, max 200 sec)
//
// For DIALOG_MENU add sub keys for each option with these fields:
//  "command" - (string) client command to run if selected
//  "msg" - (string) button text for this option
//

// KeyValues kPanel = new KeyValues("menu");
// kPanel.SetString("title", "aaaaa");
// kPanel.SetString("msg", "Bbbbbbb");
// kPanel.SetString("command", "ccccccccc");
// kPanel.SetNum("level", 1);
// CreateDialog(client, kPanel, DialogType_Text);

public Action:cmd_physgun_switch(client, const String:command[], argc)
{
	new String:wep[256];
	Client_GetActiveWeaponName(client, wep, 256);

	if (StrEqual(wep, "weapon_physgun", bool:false) == false
	|| (StrEqual(wep, "weapon_bugbait", bool:false) == true && !toolgun_enabled[client]))
	{
		Client_ChangeWeapon(client, "weapon_bugbait");
		toolgun_enabled[client] = true;
		SendMsg_HudMsg(client, 1, -1.0, 0.55, 255, 0, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 999999.0, 0.0, "Toolgun: %s\n(Press Reload to remove items", toolgunmode_names[toolg_mode[client]]);
		// RequestFrame(cmd_jb_toolmode_changeViewModel, client);
		CreateTimer(0.1, cmd_jb_toolmode_changeViewModel, client, TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.2, cmd_jb_toolmode_changeViewModel, client, TIMER_FLAG_NO_MAPCHANGE);
		
		return Plugin_Stop;
	}
		
	// no more menus, sadge
	
	// KeyValues kMenu = new KeyValues("menu");
	
	// kMenu.SetString("title", "You have options! Press ESC!");
	// kMenu.SetString("msg", "Select tool mode");
	// kMenu.SetString("command", "");
	// kMenu.SetNum("level", 0);
	
	
	// kMenu.JumpToKey("1", true);
	// kMenu.SetString("msg", "Remover");
	// kMenu.SetString("command", "jb_toolmode 12;jb_CloseMyConsole"); //"cancelselect" closes your ESC-menu
	// kMenu.Rewind();
	
	// kMenu.JumpToKey("2", true);
	// kMenu.SetString("msg", "Weld");
	// kMenu.SetString("command", "jb_toolmode 2;jb_CloseMyConsole"); //"cancelselect" closes your ESC-menu
	// kMenu.Rewind();
	
	// kMenu.JumpToKey("3", true);
	// kMenu.SetString("msg", "Rope");
	// kMenu.SetString("command", "jb_toolmode 0;jb_CloseMyConsole"); //"cancelselect" closes your ESC-menu
	// kMenu.Rewind();
	
	// kMenu.JumpToKey("4", true);
	// kMenu.SetString("msg", "Slider (Work in Progress)");
	// kMenu.SetString("command", "jb_toolmode 8;jb_CloseMyConsole"); //"cancelselect" closes your ESC-menu
	// kMenu.Rewind();
	
	// CreateDialog(client, kMenu, DialogType_Menu);

	//show ESC menu but dont show the console
	// ClientCommand(client, "showconsole");
	// ClientCommand(client, "hideconsole");
	
	return Plugin_Continue;
}


public Action:cmd_jb_toolmode(int client, int argc)
{
	// Client_HasWeapon(int client, const char[] className)
	// Client_GetWeapon(int client, const char[] className)
	// new String weapon_bugbait[256] "weapon_bugb	ait";
	
	new String:wep[256];
	Client_GetActiveWeaponName(client, wep, 256);

	if (!StrEqual(wep, "weapon_physgun", bool:false))
	{
		Client_ChangeWeapon(client, "weapon_bugbait");
		
		new String:args[256];
		GetCmdArgString(args, 256);
		
		toolg_mode[client] = StringToInt(args);
		
		// RequestFrame(cmd_jb_toolmode_changeViewModel, client);
		CreateTimer(0.1, cmd_jb_toolmode_changeViewModel, client, TIMER_FLAG_NO_MAPCHANGE);
	}
	
	return Plugin_Handled;
}


public Action:cmd_jb_toolmode_changeViewModel(Handle:Timer, client)
{
	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		int wep = Client_GetWeapon(client, "weapon_bugbait");
		if (IsValidEntity(wep))
		{
			int iViewModel = GetEntPropEnt(client, Prop_Send, "m_hViewModel");
			if (iViewModel != 0 && iViewModel != -1)
			{
				SetEntProp(iViewModel, Prop_Send, "m_nModelIndex", g_iPhysicsGunVM, 2);
				SetEntProp(iViewModel, Prop_Send, "m_nSequence", 2);
			}
		}
	}
}


