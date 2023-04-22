/*
public Action:rebuildScores(Handle:timer)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			new String:plyname[256];
			GetClientName(i, plyname, 256);
			Format(scoresContent[i-1], 256, "%s", plyname);
		} else {
			Format(scoresContent[i-1], 256, "");
		}
	}
}


public Action:drawScoresFunc(Handle:timer)
{
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if (showScores[i] == 1)
			{
				
				curPly[i] = curPly[i] + 4;
				if (curPly[i] > 31) {curPly[i] = 0;}
				
				new line = curPly[i];
							
				new String:sline1[200];
				new String:sline2[200];
				new String:sline3[200];
				new String:sline4[200];
				
				new one = Math_Clamp(line  , 0, 32);
				new two = Math_Clamp(line+1, 0, 32);
				new tre = Math_Clamp(line+2, 0, 32);
				new fur = Math_Clamp(line+3, 0, 32);
				
				Format(sline1, sizeof(sline1), "%s", scoresContent[line]   );
				Format(sline2, sizeof(sline2), "%s", scoresContent[line+1] );
				Format(sline3, sizeof(sline3), "%s", scoresContent[line+2] );
				Format(sline4, sizeof(sline4), "%s", scoresContent[line+3] );
				
				new String:final[200];
				Format(final, sizeof(final), "%i %s\n%i %s\n%i %s\n%i %s", one, sline1, two, sline2, tre, sline3, fur, sline4);
				
				new Float:x = 0.3;
				new y = line;
				if (line > 15) {x = 0.6; y = line-15;}
				
			
				curChannel[i] = curChannel[i] + 1;
				if (curChannel[i] > 6) {curChannel[i] = 0;}

				SendMsg_HudMsg(i, curChannel[i], x, 0.0 + (y * 0.035), 255, 128, 0, 255, 255, 255, 255, 255, 0, 0.0, 0.0, 2.0, 0.0, final);
		}
	}
}
*/
