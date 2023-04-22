public Plugin:myinfo =
{
name = "jbmod chatsounds",
author = "Nafrayu",
description = "no description",
version = "1.0",
url = "nafrayu.com"
};


#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdktools_sound>
#include <entity_prop_stocks>

#pragma semicolon 1


StringMap g_chatsounds;


public OnPluginStart()
{
	// TODO: Load from file instead of defining this in code...
	g_chatsounds = new StringMap();
	SetTrieString(g_chatsounds, "rise", "vo/gman_misc/gman_riseshine.wav");
	SetTrieString(g_chatsounds, "speak english", "vo/npc/male01/vanswer01.wav");
	SetTrieString(g_chatsounds, "bullshit", "vo/npc/male01/question26.wav");
	SetTrieString(g_chatsounds, "yay", "vo/npc/Barney/ba_yell.wav");
	SetTrieString(g_chatsounds, "shit", "vo/npc/Barney/ba_ohshit03.wav");
	SetTrieString(g_chatsounds, "hax", "vo/npc/male01/hacks01.wav");
	SetTrieString(g_chatsounds, "hacks", "vo/npc/male01/hacks02.wav");
	SetTrieString(g_chatsounds, "h4x", "vo/npc/male01/thehacks01.wav");
	SetTrieString(g_chatsounds, "h4cks", "vo/npc/male01/thehacks02.wav");
	SetTrieString(g_chatsounds, "okay", "vo/npc/male01/ok02.wav");
	SetTrieString(g_chatsounds, "durka", "vo/npc/vortigaunt/vortigese11.wav");
	SetTrieString(g_chatsounds, "derka", "vo/npc/vortigaunt/vortigese12.wav");
	SetTrieString(g_chatsounds, "noes", "vo/npc/Alyx/ohno_startle01.wav");
	SetTrieString(g_chatsounds, "get down", "vo/npc/male01/getdown02.wav");
	SetTrieString(g_chatsounds, "gtfo", "vo/npc/male01/gethellout.wav");
	SetTrieString(g_chatsounds, "gtho", "vo/npc/male01/gethellout.wav");
	SetTrieString(g_chatsounds, "yeah", "vo/npc/male01/yeah02.wav");
	SetTrieString(g_chatsounds, "rofl", "vo/Citadel/br_laugh01.wav");
	SetTrieString(g_chatsounds, "lmao", "vo/Citadel/br_laugh01.wav");
	SetTrieString(g_chatsounds, "run", "vo/npc/male01/runforyourlife02.wav");
	SetTrieString(g_chatsounds, "fantastic", "vo/npc/male01/fantastic01.wav");
	SetTrieString(g_chatsounds, "headcrabs", "vo/npc/Barney/ba_headhumpers.wav");
	SetTrieString(g_chatsounds, "headhumpers", "vo/npc/Barney/ba_headhumpers.wav");
	SetTrieString(g_chatsounds, "hello", "vo/coast/odessa/nlo_cub_hello.wav");
	SetTrieString(g_chatsounds, "eek", "ambient/voices/f_scream1.wav");
	SetTrieString(g_chatsounds, "uh oh", "vo/npc/male01/uhoh.wav");
	SetTrieString(g_chatsounds, "sodomy!", "vo/ravenholm/madlaugh01.wav");
	SetTrieString(g_chatsounds, "sodomy2", "vo/ravenholm/madlaugh02.wav");
	SetTrieString(g_chatsounds, "sodomy3", "vo/ravenholm/madlaugh03.wav");
	SetTrieString(g_chatsounds, "sodomy4", "vo/ravenholm/madlaugh04.wav");
	SetTrieString(g_chatsounds, "oops", "vo/npc/male01/whoops01.wav");
	SetTrieString(g_chatsounds, "shut up", "vo/npc/male01/answer17.wav");
	SetTrieString(g_chatsounds, "shutup", "vo/npc/male01/answer17.wav");
	SetTrieString(g_chatsounds, "right on", "vo/npc/male01/answer32.wav");
	SetTrieString(g_chatsounds, "freeman", "vo/npc/male01/gordead_ques03a.wav");
	SetTrieString(g_chatsounds, "help", "vo/npc/male01/help01.wav");
	SetTrieString(g_chatsounds, "haxz", "vo/npc/male01/herecomehacks01.wav");
	SetTrieString(g_chatsounds, "hi!", "vo/npc/male01/hi01.wav");
	SetTrieString(g_chatsounds, "lets go", "vo/npc/male01/letsgo02.wav");
	SetTrieString(g_chatsounds, "moan", "vo/npc/male01/moan04.wav");
	SetTrieString(g_chatsounds, "nice", "vo/npc/male01/nice.wav");
	SetTrieString(g_chatsounds, "noo", "vo/npc/male01/no02.wav");
	SetTrieString(g_chatsounds, "oh no", "vo/npc/male01/ohno.wav");
	SetTrieString(g_chatsounds, "joygasm", "vo/npc/female01/pain06.wav");
	SetTrieString(g_chatsounds, "zombies", "vo/npc/male01/zombies01.wav");
	SetTrieString(g_chatsounds, "zombiez", "vo/npc/male01/zombies02.wav");
	SetTrieString(g_chatsounds, "da man", "bot/whos_the_man.wav");
	SetTrieString(g_chatsounds, "my house", "bot/this_is_my_house.wav");
	SetTrieString(g_chatsounds, "party", "bot/its_a_party.wav");
	SetTrieString(g_chatsounds, "watch out", "vo/npc/male01/watchout.wav");
	SetTrieString(g_chatsounds, "excuse me", "vo/npc/male01/excuseme02.wav");
	SetTrieString(g_chatsounds, "you sure?", "vo/npc/male01/answer37.wav");
	SetTrieString(g_chatsounds, "drink a big bucket of shit", "speach/obeyyourthirst.wav");
	SetTrieString(g_chatsounds, "drink a big bucket of horse dick", "speach/obeyyourthirst2.wav");
	SetTrieString(g_chatsounds, "drink a big bucket of warm pee", "speach/obeyyourthirst3.wav");
	SetTrieString(g_chatsounds, "groan", "vo/npc/male01/moan04.wav");
	SetTrieString(g_chatsounds, "gasp", "vo/npc/male01/startle01.wav");
	SetTrieString(g_chatsounds, "sorry", "vo/npc/male01/sorry01.wav");


	// HookEvent("player_chat", ev_player_chat, EventHookMode_Post);
}


// public OnEventShutdown()
// {
	// UnhookEvent("player_chat", ev_player_chat);
// }


// public Action:ev_player_chat(Handle:event, const String:name[], bool:dontBroadcast)
// {
	// new userid = GetEventInt(event, "userid");
	// new client = GetClientOfUserId(userid);
	
	// new String:chatmsg[512];
	// GetEventString(event, "text", chatmsg, sizeof(chatmsg), "");

	

	// return Plugin_Continue;
// }


public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
	if (client == 0 || !IsClientInGame(client)) {
		return Plugin_Continue;
	}

	char chatExploded[128][512];
	//turn the chat into an array of words
	// int stringAmt = ExplodeString(sArgs, " ", chatExploded, sizeof(chatExploded), sizeof(chatExploded[]));
	ExplodeString(sArgs, " ", chatExploded, sizeof(chatExploded), sizeof(chatExploded[]));

	//for each word, check if it has chat sound (see g_chatsounds above)
	for (int i=0; i < sizeof(chatExploded); i++)
	{
		char sound[256];
		//we found a word that is has a chat sound!
		if (GetTrieString(g_chatsounds, chatExploded[i], sound, sizeof(sound)))
		{
			// PrintToChatAll("%d SOUND %s\n", client, sound);
		
			PrecacheSound(sound);
			EmitSoundToAll(sound, client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.8);
		}
	}

	// PrintToChatAll("%d said %s\n", client, sArgs);
	return Plugin_Continue;
}













