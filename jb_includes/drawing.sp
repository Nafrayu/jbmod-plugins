// https://github.com/Wh1t3Rose/CSGO-SURF/tree/master/csgo/addons/sourcemod/scripting/SurfTimer

// Send beams to client
// https://forums.alliedmods.net/showpost.php?p=2006539&postcount=8

// TE_SendBeamBoxToClient(p, buffer_a, buffer_b, g_BeamSprite, g_HaloSprite, 0, 30, GetConVarFloat(g_hChecker), 1.0, 1.0, 2, 0.0, tzColor, 0, 0, i);

stock bool:IsInsideZone(client, Float:point[8][3])
{
    new Float:playerPos[3];
    
    GetEntPropVector(client, Prop_Send, "m_vecOrigin", playerPos);
    
    for(new i=0; i<3; i++)
    {
        if(point[0][i]>=playerPos[i] == point[7][i]>=playerPos[i])
        {
            return false;
        }
    }

    return true;
} 


/*
* Graphically draws a zone
*    if client == 0, it draws it for all players in the game
*   if client index is between 0 and MaxClients+1, it draws for the specified client
*/
DrawZone(client, Float:array[8][3], beamsprite, halosprite, color[4], Float:life)
{
    for(new i=0, i2=3; i2>=0; i+=i2--)
    {
        for(new j=1; j<=7; j+=(j/2)+1)
        {
            if(j != 7-i)
            {
				// void TE_SetupBeamPoints(const float start[3], const float end[3], int ModelIndex, int HaloIndex, int StartFrame, int FrameRate, float Life, float Width, float EndWidth, int FadeLength, float Amplitude, const int Color[4], int Speed)

                TE_SetupBeamPoints(array[i], array[j], beamsprite, 0, 0, 0, life, 4.0, 4.0, 1, 0.0, color, 0);
                if (client > 0) {
                    TE_SendToClient(client, 0.0);
				} else {
                    TE_SendToAll(0.0);
				}
            }
        }
    }
} 

/*
* Generates all 8 points of a zone given just 2 of its points
*/
CreateZonePoints(Float:point[8][3])
{
    for(new i=1; i<7; i++)
    {
        for(new j=0; j<3; j++)
        {
            point[i][j] = point[((i >> (2-j)) & 1) * 7][j];
        }
    }
} 

