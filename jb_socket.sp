#include <sourcemod>
#include <sdktools>
//#include sdktools_functions
#pragma semicolon 1
#include <socket>


public Plugin:myinfo =
{
	name = "jbmod spawnmenu",
	author = "Nafrayu",
	description = "no description",
	version = "1.0",
	url = "nafrayu.com"
};


new String:spawncode[MAXPLAYERS+1][256];


public OnPluginStart()
{
	// SetOption(INVALID_HANDLE, DebugMode, 1);
	
	new Handle:socket = SocketCreate(SOCKET_TCP, OnSocketErrorTrap);
	SocketSetOption(socket, SocketReuseAddr, 1);
	SocketBind(socket, "0.0.0.0", 43279);
	SocketListen(socket, socketIncomming);
	
	RegConsoleCmd("code", cmd_getspawncode);
	
	for (new i=1; i<=MaxClients; i++)
	{
		if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			new String:finalcode[256];
			
			for (new e=1; e<=4; e++)
			{
				new String:letter[2];
				Format(letter, 2, "%c", GetRandomInt(65, 90));	//ascii uppercase letters a-z
				StrCat(finalcode, 256, letter);
			}
			Format(spawncode[i], 256, finalcode);
		}
	}
}
	
	
public OnPluginEnd()
{
}



	
public Action cmd_getspawncode(int client, int args)
{
	new String:finalcode[256];
	
	for (new i=1; i<=4; i++)
	{
		new String:letter[2];
		Format(letter, 2, "%c", GetRandomInt(65, 90));	//ascii uppercase letters a-z
		StrCat(finalcode, 256, letter);
	}
	
	Format(spawncode[client], 256, finalcode);
	
	PrintToChat(client, "Your code is \"%s\" (Do not share in chat)", finalcode);
	
	return Plugin_Handled;
}


	
	
public socketIncomming(Handle:socket, Handle:newSocket, String:remoteIP[], remotePort, any:arg) 
{
	SocketSetReceiveCallback(newSocket, OnSocketReceiveTrap);
	SocketSetDisconnectCallback(newSocket, OnSocketDisconnectTrap);
	SocketSetErrorCallback(newSocket, OnSocketErrorTrap);
}

public OnSocketReceiveTrap(Handle:socket, String:receiveData[], const dataSize, any:arg)
{
	PrintToServer("* |socket selftest| trap OnSocketReceiveTrap triggered (%d bytes received)", dataSize);
	
	new String:sReceived[500];
	Format(sReceived, 500, "%s", receiveData);
	
	// PrintToServer("GOT SOCKET-----------------------");
	PrintToServer("~%s~", receiveData);
	
	// int ExplodeString(
	// const char[] text,
	// const char[] split,
	// char[][] buffers,
	// int maxStrings,
	// int maxStringLength,
	// bool copyRemainder)
	
	// string will come in like this
	// 127.0.0.1|makeprop|models/gman.mdl	
	char args[3][4000];
	ExplodeString(sReceived, "|", args, sizeof(args), sizeof(args[]));
	
	for (new i=1; i <= MaxClients; i++)
    {
        if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
        {
			// new String:sIP[256];
			// GetClientIP(i, sIP, 256);
			
			// if (StrEqual(sIP, args[0]))
			if (StrEqual("", args[1]) == bool:false && StrEqual(spawncode[i], args[1]))
			{
				new String:finalCommand[4000];
				Format(finalCommand, 4000, "%s", args[2]);
				
				FakeClientCommand(i, finalCommand);
			}
		}
	}
	

	
	// trapsReached++;
}

public OnSocketErrorTrap(Handle:socket, const errorType, const errorNum, any:arg)
{
	PrintToServer("* |socket selftest| trap OnSocketErrorTrap triggered (error %d, errno %d)", errorType, errorNum);
	// trapsReached++;
}

public OnSocketDisconnectTrap(Handle:socket, any:arg)
{
	// PrintToServer("* |socket selftest| trap OnSocketDisconnectTrap triggered");
	// trapsReached++;
}

