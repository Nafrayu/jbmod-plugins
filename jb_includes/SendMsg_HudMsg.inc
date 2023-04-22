#if defined _SendMsg_HudMsg_included
	#endinput
#endif
#define _SendMsg_HudMsg_included

#define _SendMsg_HudMsg_version "1.0"


stock SendMsg_HudMsg(client, channel, 
		Float:x, Float:y, 
		aRclr, aGclr, aBclr, aTclr, 
		bRclr, bGclr, bBclr, bTclr, 
		effect, 
		Float:fadein, Float:fadeout, 
		Float:holdtime, Float:fxtime, 
		//const String:szMsg[]
		const String:format[], any:...)
	{
	
	new Handle:hBf;
	
	if (!client) {
		hBf = StartMessageAll("HudMsg");
	} else {
		hBf = StartMessageOne("HudMsg", client);
	}
	
	if (hBf != INVALID_HANDLE) {
		BfWriteByte(hBf, channel);//channel
		BfWriteFloat(hBf, x);//x ( -1 = center )
		BfWriteFloat(hBf, y);//y ( -1 = center )
		//second color
		BfWriteByte(hBf, aRclr);//r1
		BfWriteByte(hBf, aGclr);//g1
		BfWriteByte(hBf, aBclr);//b1
		BfWriteByte(hBf, aTclr);//a1//transparent?
		//init color
		BfWriteByte(hBf, bRclr);//r2
		BfWriteByte(hBf, bGclr);//g2
		BfWriteByte(hBf, bBclr);//b2
		BfWriteByte(hBf, bTclr);//a2
		BfWriteByte(hBf, effect);//effect (0 is fade in/fade out; 1 is flickery credits; 2 is write out)
		BfWriteFloat(hBf, fadein);//fadeinTime (message fade in time - per character in effect 2)
		BfWriteFloat(hBf, fadeout);//fadeoutTime
		BfWriteFloat(hBf, holdtime);//holdtime
		BfWriteFloat(hBf, fxtime);//fxtime (effect type(2) used)
		decl String:sBuffer[256];
		VFormat(sBuffer, sizeof(sBuffer), format, 19);
		BfWriteString(hBf, sBuffer);//Message
		//BfWriteString(hBf, szMsg);//Message
		EndMessage();
	}
}
