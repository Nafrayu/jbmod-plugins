// public Action:ecs_timer_test(Handle:timer)
// {

// }

	
public Action:cmd_e_test(int client, int argc)
{	
	// new Float:ass[3] = {1.0,0.0,0.0};
	// new Float:ass2[3] = {1.0,0.0,0.0};
	// MoveVectorPosition3D(ass, Float:{0.0,90.0,0.0}, Float:{90.0,0.0,0.0});
	
	// PrintToChat(client, "%f %f %f", ass[0], ass[1], ass[2]);
	// Phys_LocalToWorld(0, ass, Float:{1.0,0.0,0.0} );
	// Phys_WorldToLocal(0, ass, Float:{1.0,0.0,0.0} );
	
	float localpos[3];
	float localang[3];
	
	// 1st - 2nd = final
	WTOL(Float:{0.0,0.0,0.0}, Float:{10.0,0.0,0.0}, Float:{0.0,0.0,0.0}, Float:{5.0,0.0,0.0}, localpos, localang);
	
	PrintToChat(client, "WTOL p %f %f %f", localpos[0], localpos[1], localpos[2]);
	PrintToChat(client, "WTOL a %f %f %f", localang[0], localang[1], localang[2]);
	
	float worldpos[3];
	float worldang[3];
	
	// 1st + 2nd = final
	LTOW(Float:{0.0,0.0,0.0}, Float:{10.0,0.0,0.0}, Float:{0.0,0.0,0.0}, Float:{5.0,0.0,0.0}, worldpos, worldang);
	
	PrintToChat(client, "LTOW p %f %f %f", worldpos[0], worldpos[1], worldpos[2]);
	PrintToChat(client, "LTOW a %f %f %f", worldang[0], worldang[1], worldang[2]);
	
	float propAngOld[3] = {1.0,0.0,0.0};
	float myDiff[3] = {90.0,0.0,0.0};
	float rotated[3] = {0.0,0.0,0.0};
	
	VectorRotate(propAngOld, myDiff, rotated);
	PrintToChat(client, "rotated a %f %f %f", rotated[0], rotated[1], rotated[2]);

	return Plugin_Handled;
}

// WTOL p 0.000000 0.000000 0.000000
// WTOL a 5.000000 0.000000 0.000000
// LTOW p 0.000000 0.000000 0.000000
// LTOW a 15.000001 0.000000 0.000000














