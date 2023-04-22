#if defined _SendKeyHintText_included
	#endinput
#endif
#define _SendKeyHintText_included

#define _SendKeyHintText_version "1.0"



stock SendKeyHintText(client, const String:format[], any:...)
	{
	
	new Handle:hBf;
	
	if (!client) {
		hBf = StartMessageAll("KeyHintText");
	} else {
		hBf = StartMessageOne("KeyHintText", client);
	}
	
	if (hBf != INVALID_HANDLE) {
		BfWriteByte(hBf, 1);//channel

		decl String:sBuffer[256];
		VFormat(sBuffer, sizeof(sBuffer), format, 3);
		BfWriteString(hBf, sBuffer);//Message
		//BfWriteString(hBf, szMsg);//Message
		EndMessage();
	}
}
