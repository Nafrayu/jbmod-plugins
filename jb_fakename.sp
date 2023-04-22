#include <sourcemod>
#include <sdktools>
#pragma semicolon 1
#define PLUGIN_VERSION "6.9.6.9"


public Plugin:myinfo =
{
	name = "NameUtils",
	author = "bt",
	description = "jb_fakename",
	version = PLUGIN_VERSION,
	url = "hl2.world"
};


public OnPluginStart ()
{
	RegConsoleCmd("sm_cname", FakeClientName);
	RegAdminCmd ("sm_acname", AdminFakeClientName, ADMFLAG_RCON);
}


public Action:FakeClientName (client, args)
{
	char arg1[128];
	GetCmdArg(1, arg1, sizeof(arg1)); // new name

	if (
   StrContains(arg1, "nigger", false) != -1
|| StrContains(arg1, "faggot", false) != -1
|| StrContains(arg1, "faggot", false) != -1	
|| StrContains(arg1, "9/11", false) != -1
|| StrContains(arg1, "ejaculat", false) != -1
|| StrContains(arg1, "fagg", false) != -1
|| StrContains(arg1, "fagot", false) != -1
|| StrContains(arg1, "fagots", false) != -1
|| StrContains(arg1, "fags", false) != -1
|| StrContains(arg1, " fag", false) != -1
|| StrContains(arg1, "hitler", false) != -1
|| StrContains(arg1, "kyke", false) != -1
|| StrContains(arg1, "nazi", false) != -1
|| StrContains(arg1, "negro", false) != -1
|| StrContains(arg1, "nigg", false) != -1
|| StrContains(arg1, "tranny", false) != -1
|| StrContains(arg1, "kys", false) != -1
|| StrContains(arg1, "kill yourself", false) != -1
|| StrContains(arg1, "nigga", false) != -1
|| StrContains(arg1, "sexu", false) != -1
|| StrContains(arg1, "teststring123", false) != -1
	)
	{
		// do nothing
	}
	else
	{
		SetClientName(client, arg1);
	}
	
	return Plugin_Handled;
}

public Action:AdminFakeClientName (client, args)
{
	char arg1[128];
	char arg2[128];
	GetCmdArg(1, arg1, sizeof(arg1)); // target
	GetCmdArg(2, arg2, sizeof(arg2)); // new name
	
	new target = FindTarget(client, arg1, false, false);
	
	if (target >= 1)
	{
		if (
		   StrContains(arg2, "nigger", false) != -1
		|| StrContains(arg2, "faggot", false) != -1
		|| StrContains(arg2, "faggot", false) != -1	
		|| StrContains(arg2, "9/11", false) != -1
		|| StrContains(arg2, "ejaculat", false) != -1
		|| StrContains(arg2, "fagg", false) != -1
		|| StrContains(arg2, "fagot", false) != -1
		|| StrContains(arg2, "fagots", false) != -1
		|| StrContains(arg2, "fags", false) != -1
		|| StrContains(arg2, " fag", false) != -1
		|| StrContains(arg2, " sex", false) != -1
		|| StrContains(arg2, "hitler", false) != -1
		|| StrContains(arg2, "kyke", false) != -1
		|| StrContains(arg2, "nazi", false) != -1
		|| StrContains(arg2, "negro", false) != -1
		|| StrContains(arg2, "nigg", false) != -1
		|| StrContains(arg2, "tranny", false) != -1
		|| StrContains(arg2, "kys", false) != -1
		|| StrContains(arg2, "kill yourself", false) != -1
		|| StrContains(arg2, "nigga", false) != -1
		|| StrContains(arg2, "sexu", false) != -1
		)
		{
			// do nothing
		}
		else
		{
			SetClientName(target, arg2);
		}
	}
	else
	{
		ReplyToCommand(client, "Usage: sm_cname <target> <name>");
	}
	
	return Plugin_Handled;
}