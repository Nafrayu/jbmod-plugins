public Plugin:myinfo =
{
	name = "jbmod - restrict player models",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


new String:g_PlayerModels[MAXPLAYERS+1][256];
new Handle:h_timer_PlayerModelChecker = INVALID_HANDLE;


#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>


#pragma semicolon 1


public OnPluginStart()
{
	h_timer_PlayerModelChecker = CreateTimer(10.0, timer_PlayerModelChecker, _, TIMER_REPEAT);
}


public OnClientPutInServer(client)
{
	// QueryClientConVar(client, "cl_playermodel", CheckPlayerModelClientConVar, client);
}


public OnPluginEnd()
{
	KillTimer(h_timer_PlayerModelChecker);
}


// public OnEventShutdown()
// {
	// UnhookEvent("player_disconnect", ev_playerdisconnect);
// }


public Action:timer_PlayerModelChecker(Handle:timer) {
    for (new i=1; i<=MaxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
        {
            QueryClientConVar(i, "cl_playermodel", CheckPlayerModelClientConVar, i);
        }
    }
}


public CheckPlayerModelClientConVar(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[]) {
	
	// PrintToChat(client, "%s model!", cvarValue);
	
    if (strcmp(cvarName, "cl_playermodel", true) == 0)
	//we are only interested in changes of cl_playermodel
    {
        // if (strcmp(cvarValue, g_PlayerModels[client]) != 0)
		// the player model has changed below this point
        // {
            strcopy(g_PlayerModels[client], 256, cvarValue);

            if (StrContains(cvarValue, "..", bool:false) != -1
            || StrContains(cvarValue, "_gesture", bool:false) != -1
            || StrContains(cvarValue, "_anim", bool:false) != -1
            || StrContains(cvarValue, "_gst", bool:false) != -1
            || StrContains(cvarValue, "_pst", bool:false) != -1
            || StrContains(cvarValue, "_shd", bool:false) != -1
            || StrContains(cvarValue, "_ss", bool:false) != -1
            || StrContains(cvarValue, "_posture", bool:false) != -1
			|| StrContains(cvarValue, "skybox", bool:false) != -1
            || StrContains(cvarValue, "_anm", bool:false) != -1
            || StrContains(cvarValue, "ghostanim", bool:false) != -1
            || StrContains(cvarValue, "_paths", bool:false) != -1
            || StrContains(cvarValue, "_shared", bool:false) != -1
            || StrContains(cvarValue, "maps", bool:false) != -1
            || StrContains(cvarValue, ".bsp", bool:false) != -1
			|| StrContains(cvarValue, ".vtf", bool:false) != -1
			|| StrContains(cvarValue, ".vmt", bool:false) != -1
			|| StrContains(cvarValue, ".spr", bool:false) != -1
            || FileExists(cvarValue, bool:true) == false
			|| StrContains(cvarValue, "/player/", bool:false) == -1
			)
			//the player model is illegal or doesnt exist on the server
			//change it back to alyx
            {
				// PrintToChat(client, "Illegal model!");
                ClientCommand(client, "cl_playermodel models/player/alyx.mdl");
                SetClientInfo(client, "cl_playermodel", "models/player/alyx.mdl");
            }
        // }
    }
}

