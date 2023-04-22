// chat must begin with \x01 to activate color codes
// \x07 followed by a hex code in RRGGBB format
// \x08 followed by a hex code with alpha in RRGGBBAA format


public Action:OnSayCmd(client, const String:command[], argc)
{
	if (g_lastchat[client] > GetTime()) {
		return Plugin_Stop;
	}
	g_lastchat[client] = GetTime() + 1;

	new String:args[256];
	GetCmdArgString(args, 256);
	StripQuotes(args);
	
	new String:plyname[256];
	new String:plynameColored[256];
	GetClientName(client, plyname, 256);
	// if (GetUserAdmin(client) != INVALID_ADMIN_ID)
	// {
		Format(plynameColored, sizeof(plynameColored), "\x01\x07FF00FF%s", plyname);
	// }
	// else
	// {
		// Format(plynameColored, sizeof(plynameColored), "\x01\x0700BBFF%s", plyname);
	// }
	
	// Format(String:buffer[], maxlength, const String:format[], any:...);
	

	
	new String:finalchat[256];
	StrCat(finalchat, 256, plynameColored);
	StrCat(finalchat, 256, "\x07FFFFFF: ");
	StrCat(finalchat, 256, args);
	
	decl String:arg1[256];
	GetCmdArg(1, arg1, sizeof(arg1));
	
	decl String:start[256];
	Format(start, 2, "%s", arg1);

	if (!strcmp(start, "!")) {
		 return Plugin_Handled;
	}

	if (StrEqual(lastmessage[client], finalchat))
	{
		PrintToChat(client, "Stop flooding.");
		return Plugin_Stop;
	}
	
	Format(lastmessage[client], 256, finalchat);
	
	if (
   StrContains(finalchat, "nigger", false) != -1
|| StrContains(finalchat, "faggot", false) != -1
|| StrContains(finalchat, "faggot", false) != -1	
|| StrContains(finalchat, "9/11", false) != -1
|| StrContains(finalchat, "ejaculat", false) != -1
|| StrContains(finalchat, "fagg", false) != -1
|| StrContains(finalchat, "fagot", false) != -1
|| StrContains(finalchat, "fagots", false) != -1
|| StrContains(finalchat, "fags", false) != -1
|| StrContains(finalchat, " fag", false) != -1
|| StrContains(finalchat, " sex", false) != -1
|| StrContains(finalchat, "hitler", false) != -1
|| StrContains(finalchat, "kyke", false) != -1
|| StrContains(finalchat, "nazi", false) != -1
|| StrContains(finalchat, "negro", false) != -1
|| StrContains(finalchat, "nigg", false) != -1
|| StrContains(finalchat, "tranny", false) != -1
|| StrContains(finalchat, "kys", false) != -1
|| StrContains(finalchat, "kill yourself", false) != -1
|| StrContains(finalchat, "nigga", false) != -1
|| StrContains(finalchat, "sexu", false) != -1
	)
	{
		// only send this to the sender (shadowban)
		PrintToConsole(client, arg1);
		PrintToChat(client, finalchat);
	} else {
		// send to everyone
		for (new i=1; i<=MaxClients; i++)
		{
			if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				PrintToConsole(i, arg1);
				PrintToChat(i, finalchat);
			}
		}
	}
		
	return Plugin_Handled;
} 

