public Plugin:myinfo =
{
	name = "jbmod security 2",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


#include <steamworks>


#pragma semicolon 1


public OnMapStart()
{
	// ████████
	CreateTimer(0.0, setrules);

}


public Action:setrules(Handle:Timer)
{
	SteamWorks_ClearRules();
	// SteamWorks_SetGameData("a");
	// SteamWorks_SetMapName("████████");
	SteamWorks_SetGameDescription("███████████████████████████████");
}

